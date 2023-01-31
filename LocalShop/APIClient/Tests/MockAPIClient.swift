@testable import LocalShop

final class MockAPIClient: APIClientRequestable {
    var executeRequest: ((_ request: Any) -> Result<Any, APIError>)?
    private(set) var executeCalled = false

    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where V == T.ResponseObject {
        executeCalled = true
        guard let makeRequest = executeRequest else {
            throw APIError.unknown
        }
        let result = makeRequest(request)
        switch result {
        case let .success(value as V):
            return value
        case let .failure(error):
            throw error
        case .success:
            throw APIError.unknown
        }
    }
}
