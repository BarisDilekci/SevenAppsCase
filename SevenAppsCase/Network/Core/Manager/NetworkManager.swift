//
//  NetworkManager.swift
//  SevenAppsCase
//
//  Created by Barış Dilekçi on 14.02.2025.
//


 /*  Network Manager kullanmamın amacı: HTTP isteklerini tek bir yerde toplamak için ve kod tekrarını engellemek için manager sınıfı oluşturdum. protcol ile request sınıfı oluşturdum ve implements ettim, protocol kullandığım için mock data ile test etme şansım oldu. Final class kullanmamın amacı ise; Network Manager sınıfının inheritance ile genişletilmesini engelledim. Böylece daha performanslı ve daha stabil çalışmasını sağlamaya çalıştım. Çünkü sınıf türetilmediği için başka bir sınıfta türetilemiyor.
  */

import Foundation

protocol INetworkManager {
    func request<T: Decodable>(_ endpoint: EndPoint, completion: @escaping (Result<T, Error>) -> ())
}

final class NetworkManager: INetworkManager {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T>(_ endpoint: EndPoint, completion: @escaping (Result<T, Error>) -> ()) where T: Decodable {
        let task = session.dataTask(with: endpoint.request()) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Network Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Geçersiz yanıt"])))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Hatalı HTTP yanıtı: \(httpResponse.statusCode)"])))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Data Error", code: -2, userInfo: [NSLocalizedDescriptionKey: "Boş veri alındı"])))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NSError(domain: "Decoding Error", code: -3, userInfo: [NSLocalizedDescriptionKey: "JSON dönüşümü başarısız: \(error.localizedDescription)"])))
            }
        }
        task.resume()
    }
}
