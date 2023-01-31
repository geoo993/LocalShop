import Foundation
@testable import LocalShop

final class MockHTTPSession: HTTPSession {
    private var stub: Stub?
    
    func register(stub: Stub) {
        self.stub = stub
    }

    func data(from urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        guard
            let stub,
            urlRequest.httpMethod == stub.method.rawValue,
            let url = urlRequest.url
        else {
            throw APIError.unknown
        }
        guard let response: HTTPURLResponse = .init(
            url: url,
            statusCode: stub.statusCode,
            httpVersion: nil,
            headerFields: nil
        ) else {
            throw APIError.responsefailed
        }
        return (stub.data, response)
    }
}

extension MockHTTPSession {
    struct Stub {
        let path: String
        let method: HTTPMethod
        let statusCode: Int
        let data: Data
    }
}
