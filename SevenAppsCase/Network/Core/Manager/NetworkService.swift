//
//  NetworkService.swift
//  SevenAppsCase
//
//  Created by Barış Dilekçi on 14.02.2025.
//

/* Network service kısmını da Network manager kısmından soyutlamak için kullandım ve ayrıca API çağrılarını tek bir yerden yönetmek için kullandım.
 */

import Foundation

protocol INetworkService {
    func fetchUserData(completion: @escaping (Result<[User], Error>) -> Void)
    func fetchUserDetailData(id: Int, completion: @escaping (Swift.Result<User, Error>) -> ())
}

final class NetworkService: INetworkService {
    private let networkManager: INetworkManager
    
    init(networkManager: INetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchUserData(completion: @escaping (Result<[User], Error>) -> Void) {
        let endPoint = EndPoint.fetchUserData
        networkManager.request(endPoint, completion: completion)
    }
    
    func fetchUserDetailData(id: Int, completion: @escaping (Result<User, any Error>) -> ()) {
        let endpoint = EndPoint.fetchUserDetail(id: id)
        
        networkManager.request(endpoint) { (result: Result<User, Error>) in
            switch result {
            case .success(let userDetail):
                print("Fetched User Detail: \(userDetail)")
                completion(.success(userDetail))
            case .failure(let error):
                print("Error fetching User detail: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
    }  
}
