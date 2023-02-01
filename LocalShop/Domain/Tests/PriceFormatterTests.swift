import XCTest
@testable import LocalShop

final class PriceFormatterTests: XCTestCase {
    func testPriceInDollar() async throws {
        let amount: Double = 182993
        let locale = Locale(identifier: "en_US")
        let result = PriceFormatter.money(amount: amount, locale: locale)
        XCTAssertEqual(result, "$182,993")
        
        let amount2: Double = -1993
        let result2 = PriceFormatter.money(amount: amount2, locale: locale)
        XCTAssertEqual(result2, "-$1,993")
    }
    
    func testPriceInPounds() async throws {
        let amount: Double = 182993
        let locale = Locale(identifier: "en_UK")
        let result = PriceFormatter.money(amount: amount, locale: locale)
        XCTAssertEqual(result, "£182,993")
        
        let amount2: Double = -1993
        let result2 = PriceFormatter.money(amount: amount2, locale: locale)
        XCTAssertEqual(result2, "-£1,993")
    }
}
