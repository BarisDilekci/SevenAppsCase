//
//  EndPoint.swift
//  SevenAppsCase
//
//  Created by Barış Dilekçi on 14.02.2025.
//

/* Burasını oluşturmamın amacı url ve istek dağınıklığını bir yere toplamak. Eğer POST, DELETE ve  UPDATE işlemeri olsaydı burada method içinde yapacaktım. Böylece ViewModel içinde daha az görev olacak ve yönetmek kolay olacaktı.*/
    import Foundation

    protocol EndPointProtocol {
        var baseURL: String { get }
        var path: String { get }
        var method: HTTPMethodType { get }
        
        func request() -> URLRequest
    }

    enum EndPoint: EndPointProtocol {
        case fetchUserData
        case fetchUserDetail(id: Int)

        var baseURL: String {
            return AppConstants.API.baseURL
        }

        var path: String {
            switch self {
            case .fetchUserData:
                return AppConstants.API.path
            case .fetchUserDetail(id: let id ):
                return "\(AppConstants.API.path)/\(id)"
            }
        }

        var method: HTTPMethodType {
            switch self {
            case .fetchUserData:
                return .get
            case .fetchUserDetail(id: let id ):
                return .get
            }
        }

        func request() -> URLRequest {
            guard var urlComponents = URLComponents(string: baseURL) else {
                fatalError("Geçersiz baseURL: \(baseURL)")
            }

            urlComponents.path = path

            guard let url = urlComponents.url else {
                fatalError("URL oluşturulamadı: \(urlComponents)")
            }

            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue

            return request
        }
    }
