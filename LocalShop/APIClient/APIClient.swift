import Foundation

enum APIError: Error {
    case unknown
    case invalidUrl
    case invalidUrlComponent
    case responsefailed
}

enum HTTPMethod: String {
    case get = "GET"
}

protocol HTTPRequest {
    associatedtype ResponseObject = Any
    var baseUrl: URL? { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var timeoutInterval: TimeInterval { get }
}

extension HTTPRequest {
    var baseUrl: URL? { URL(string: "https://dummyjson.com") }
    var httpMethod: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? { nil }
    var timeoutInterval: TimeInterval { 30 }
}

protocol HTTPSession {
    func data(from urlRequest: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPSession {
    func data(from urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: urlRequest)
    }
}

protocol APIClientRequestable {
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V
}

final class APIClient: APIClientRequestable  {
    private let session: HTTPSession
    
    init(session: HTTPSession = URLSession.shared) {
        self.session = session
    }
    
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V {
        let url = try makeUrl(request: request)
        var urlRequest = URLRequest(url: url, timeoutInterval: request.timeoutInterval)
        urlRequest.httpMethod = request.httpMethod.rawValue
        let (data, response) = try await session.data(from: urlRequest)
        guard
            let responseValue = response as? HTTPURLResponse,
            200..<300 ~= responseValue.statusCode
        else {
            throw APIError.responsefailed
        }
        return try JSONDecoder().decode(T.ResponseObject.self, from: data)
    }
    
    private func makeUrl<T: HTTPRequest>(request: T) throws -> URL {
        guard let baseUrl = request.baseUrl else {
            throw APIError.invalidUrl
        }
        var urlComponent = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        urlComponent?.path = request.path
        urlComponent?.queryItems = request.queryItems
        guard let url = urlComponent?.url else {
            throw APIError.invalidUrlComponent
        }
        return url
    }
}
