import XCTest
@testable import LocalShop

final class FetchProductsRequestTests: XCTestCase {
    private var mockUrlSession: MockHTTPSession!
    private var apiclient: APIClient!
    
    override func setUp() {
        super.setUp()
        mockUrlSession = MockHTTPSession()
        apiclient = APIClient(session: mockUrlSession)
    }
    
    override func tearDown() {
        mockUrlSession = nil
        apiclient = nil
        super.tearDown()
    }
    
    func testRequest() async throws {
        mockUrlSession.register(
            stub: .init(
                path: "/product",
                method: .get,
                statusCode: 200,
                data: try FetchProductsRequest.dummy()
            )
        )
        let request = FetchProductsRequest(limit: 10, skip: 0)
        let result = try await apiclient.execute(request: request)
        XCTAssertEqual(result.data.count, 5)
        XCTAssertEqual(result.data.first?.title, "iPhone 9")
    }
}
