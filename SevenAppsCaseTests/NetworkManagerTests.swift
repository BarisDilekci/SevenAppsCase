//
//  SevenAppsCaseTests.swift
//  SevenAppsCaseTests
//
//  Created by Barış Dilekçi on 14.02.2025.
//

import XCTest
@testable import SevenAppsCase


/* Network katmanını UI ile kullanmadan önce mock session ve mock datalar ile burada test ettim. Eğer fail olsaydı network katmanını gözden geçirecektim. İleride network katmanı ile ya da herhangi bir şeyi update yapınca, direkt burası ile katmanı test edebiliriz. */
final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        networkManager = NetworkManager(session: mockURLSession)
    }
    
    func test_request_success() {
        
        let mockUserData = """
        [
            {
                "id": 1,
                "name": "Seven",
                "username": "Apps",
                "email": "sevenApps@test"
            }
        ]
        """.data(using: .utf8)
        
        mockURLSession.data = mockUserData
        mockURLSession.response = HTTPURLResponse(url: URL(string: AppConstants.API.fullURL)!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        let expectation = self.expectation(description: "Success")
        
        networkManager.request(EndPoint.fetchUserData) { (result: Result<[User], Error>) in
            switch result {
            case .success(let users):
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.id, 1)
                XCTAssertEqual(users.first?.name, "Seven")
                XCTAssertEqual(users.first?.username, "Apps")
                XCTAssertEqual(users.first?.email, "sevenApps@test")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_request_failure() {
        mockURLSession.error = NSError(domain: "Test", code: 404, userInfo: nil)
        
        mockURLSession.response = HTTPURLResponse(url: URL(string: AppConstants.API.fullURL)!,
                                                  statusCode: 404,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        let expectation = self.expectation(description: "Network error")
        
        networkManager.request(EndPoint.fetchUserData) { (result: Result<[User], Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

class MockURLSession: URLSession {
    var data: Data?
    var error: Error?
    var response: URLResponse?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, response, error)
        return URLSessionDataTask()
    }
}
