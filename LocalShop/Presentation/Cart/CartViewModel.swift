import Foundation
import SwiftUI

final class CartViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var cartValue: String = ""
    @Published var showErrorMessage = false
    
    private let repository: ProductsRepository
    
    init(repository: ProductsRepository = DefaultProductsRepository()) {
        self.repository = repository
    }
    
    func loadProducts() {
        do {
            let results = try repository.cartProducts()
            updateProducts(with: results)
            showErrorMessage = false
        } catch {
            showErrorMessage = true
        }
    }
    
    func didUpdate(product: Product, units: Int) {
        do {
            try repository.updateQuantity(of: product, units: units)
            loadProducts()
        } catch {
            showErrorMessage = true
        }
    }
    
    func dismissAlert() {
        showErrorMessage = false
    }
    
    private func updateProducts(with results: [Product]) {
        products = results
        cartValue = PriceFormatter.money(
            amount: results.reduce(0.0) { current, product in
                current + (product.price * Double(product.quantity))
        })
    }
}
