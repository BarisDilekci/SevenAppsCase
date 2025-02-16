//
//  UserDetailViewController.swift
//  SevenAppsCase
//
//  Created by Barış Dilekçi on 16.02.2025.
//

import UIKit

final class UserDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: UserDetailViewModel
    
    // MARK: - UI Elements
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .blue
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithUser()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneLabel)
        view.addSubview(websiteLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 20),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - Configure UI with User Data
    private func configureWithUser() {
        nameLabel.text = "Name: \(viewModel.userName)"
        emailLabel.text = "Email: \(viewModel.email)"
        phoneLabel.text = "Phone: \(viewModel.phone)"
        websiteLabel.text = "Website: \(viewModel.website)"
    }
}
