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
    
    func testSaveAndDeletedProducts() throws {
        let iPhone: Product = .fixture()
        let desk: Product = .fixture(id: 291, title: "Standing Desk")
        let isIphoneSaved = try sut.save(product: iPhone)
        XCTAssertTrue(isIphoneSaved)
        let isDeskSaved = try sut.save(product: desk)
        XCTAssertTrue(isDeskSaved)
        let cart = try sut.cartProducts()
        XCTAssertEqual(cart, [iPhone, desk])
        
        let isIphoneSaved2 = try sut.save(product: iPhone)
        XCTAssertFalse(isIphoneSaved2)
        let cart2 = try sut.cartProducts()
        XCTAssertEqual(cart2, [desk])
        
        let isDeskSaved2 = try sut.save(product: desk)
        XCTAssertFalse(isDeskSaved2)
        let cart3 = try sut.cartProducts()
        XCTAssertTrue(cart3.isEmpty)
    }
    
    func testUpdateQuantity() throws {
        let iPhone: Product = .fixture()
        let isIphoneSaved = try sut.save(product: iPhone)
        XCTAssertTrue(isIphoneSaved)
        
        try sut.updateQuantity(of: iPhone, units: 3)
        let cart = try sut.cartProducts()
        XCTAssertEqual(cart.first?.quantity, 3)
    }
}
