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
    func fetchUserData(completion: @escaping (Result<User, Error>) -> Void)
}

final class NetworkService: INetworkService {
    
    private let networkManager: INetworkManager

    init(networkManager: INetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchUserData(completion: @escaping (Result<User, Error>) -> Void) {
        let endPoint = EndPoint.fetchUserData
        networkManager.request(endPoint, completion: completion)
    }
}
