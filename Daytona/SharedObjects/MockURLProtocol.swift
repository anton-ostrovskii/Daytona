//
//  MockURLProtocol.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/5/22.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var mockData = [String: Data]()

    override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let url = request.url {
            let path: String
            if let queryString = url.query {
                path = url.relativePath + "?" + queryString
            } else {
                path = url.relativePath
            }
            let data = MockURLProtocol.mockData[path]!
            let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            client?.urlProtocol(self, didReceive: urlResponse, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
