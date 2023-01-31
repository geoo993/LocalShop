import Foundation
import XCTest
@testable import LocalShop

final class ProductsRepositoryTests: XCTestCase {
    var apiClient: MockAPIClient!
    var sut: ProductsRepository!
    
    override func setUp() {
        apiClient = MockAPIClient()
        sut = DefaultProductsRepository(apiclient: apiClient, context: .mock())
    }

    override func tearDown() {
        apiClient = nil
        sut = nil
        super.tearDown()
    }

    func testFetchProductsFails() async {
        apiClient.executeRequest = { _ in
            return .failure(.unknown)
        }
        XCTAssertFalse(apiClient.executeCalled)
        let products = try? await sut.fetchProducts(limit: 0, skip: 0)
        XCTAssertNil(products)
    }
        
    func testFetchProductsSucceeds() async throws {
        apiClient.executeRequest = {
            if $0 is FetchProductsRequest, let value = try? FetchProductsRequest.fixture() {
                return .success(value)
            }
            return .failure(.unknown)
        }
        XCTAssertFalse(apiClient.executeCalled)
        let result = try await sut.fetchProducts(limit: 5, skip: 0)
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result.first?.title, "iPhone 9")
    }
    
    func testSaveAndDeletedProductss() throws {
        let iPhone: Product = .fixture()
        let desk: Product = .fixture(id: 291, title: "Standing Desk")
        try sut.save(product: iPhone)
        try sut.save(product: desk)
        let cart = try sut.cartProducts()
        XCTAssertEqual(cart, [iPhone, desk])
        
        try sut.delete(product: iPhone)
        let cart2 = try sut.cartProducts()
        XCTAssertEqual(cart2, [desk])
        
        try sut.delete(product: desk)
        let cart3 = try sut.cartProducts()
        XCTAssertTrue(cart3.isEmpty)
    }
}
