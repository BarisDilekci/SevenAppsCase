//
//  ViewController.swift
//  SevenAppsCase
//
//  Created by Barış Dilekçi on 14.02.2025.
//

import UIKit

/*
 UserListViewBuilder yaptığım işlem  Factory Pattern diye geçiyor.
 Nesne oluşturmayı tek bir yerden yönetmek için tercih ettim. Sebebi ise; başka bir yerde bu Controlleri kullanırken bir sürü bağımlılık girmek gerekecek(ViewModel, controller vs). Bunları tek tek yazmak ve kod sağlığını düzenlemek için bu şekilde yaptım.
 */
enum UserListViewBuilder {
    static func generate() -> UIViewController {
        let viewModel = UserListViewModel(networkService: NetworkService.init(networkManager: NetworkManager()))
        let viewController = UserListViewController(viewModel: viewModel)
        return viewController
    }
}

final class UserListViewController: UIViewController {
    
    private let viewModel: UserListViewModel
    private let reuseIdentifier = "UserCell"
    
    //MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()
    
    //MARK: - Life cycle
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.onUserDetailFetched = { [weak self] userDetail in
                   guard let self = self else { return }
                   DispatchQueue.main.async {
                       let detailViewModel = UserDetailViewModel(user: userDetail)
                       let detailViewController = UserDetailViewController(viewModel: detailViewModel)
                       self.navigationController?.pushViewController(detailViewController, animated: true)
                   }
               }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    //MARK: Functions
    private func setup() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { errorMessage in
            print("Error: \(errorMessage)")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(at: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}
