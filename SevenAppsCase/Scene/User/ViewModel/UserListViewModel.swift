//
//  UserListViewModel.swift
//  SevenAppsCase
//
//  Created by Barış Dilekçi on 16.02.2025.
//

import UIKit

/*
 Burada Interface kullanmamın amacı ViewModel'in Controller'a bağlı olmaması, test yazarken zorlanmamamız ve genişletme yapılırken daha rahat ve sorunsuz bir şekilde genişletme yapabilmek için.
 ViewDidLoad ve table'in propertilerini kullanmamın amacı ise; View içinde sadece render işlemlerini yapmak istediğimden. Açılırken optimizasyon ve yönetmesi kolay olsun diye buraya taşıdım. Bu şekilde daha modüler ve geliştirmeye açık bir yapı oluşturdum.
 Bir diğer yaptığım şey ise bağımlılıkları azaltmak oldu. Proje kapsamında Manager katmanlarında da yaptığım(yapmaya çalıştığım) Dependency Injection ile dışarıdan bağımlılık vererek sınıflar arası bağımlığı azaltmaya çalıştım.

 */
protocol UserListViewHomeInterface {
    func viewDidLoad()
    func numberOfItemsInSection() -> Int
    func cellForRow(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    func userCellViewModel(at indexPath: IndexPath) -> User
    func didSelectRow(at indexPath: IndexPath)
}

final class UserListViewModel: UserListViewHomeInterface {
  
    private let networkService: INetworkService
    private var users: [User] = []
    
    var onError: ((String) -> Void)?
    var onDataFetched: (() -> Void)?
    var onUserDetailFetched: ((User) -> Void)?

    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        fetchUsers()
    }
    

    func getUser(indexPath: IndexPath) -> User  {
        return users[indexPath.row]
        }
    
    func numberOfItemsInSection() -> Int {
        return users.count
    }
    
    func cellForRow(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserListTableViewCell else {
            return UITableViewCell()
        }
      
        let user = users[indexPath.row]
        cell.configure(with: user)
        
        return cell
    }
    
    func didSelectRow(at indexPath: IndexPath) {
          let user = getUser(indexPath: indexPath)
                  fetchUserDetail(id: user.id ?? 1) { [weak self] result in
                      switch result {
                      case .success(let userDetail):
                          self?.onUserDetailFetched?(userDetail)
                      case .failure(let error):
                          self?.onError?(error.localizedDescription)
                      }
                  }
      }
      
    
    func userCellViewModel(at indexPath: IndexPath) -> User {
        let user = getUser(indexPath: indexPath)
        return User(id: user.id, name: user.name, phone: user.phone, email: user.email, website: user.website)
    }
}


extension UserListViewModel {
    private func fetchUsers() {
        networkService.fetchUserData { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.onDataFetched?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func fetchUserDetail(id: Int, completion: @escaping (Result<User, Error>) -> Void) {
            networkService.fetchUserDetailData(id: id) { result in
                switch result {
                case .success(let userDetail):
                    completion(.success(userDetail))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
