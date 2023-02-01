import SwiftUI

final class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published private(set) var showErrorMessage = false
    
    private let repository: ProductsRepository
    private let limit: Int
    private var skip = 0
    
    init(
        repository: ProductsRepository = DefaultProductsRepository(),
        limit: Int = 10
    ) {
        self.repository = repository
        self.limit = limit
    }
    
    @MainActor
    func loadProducts() {
        Task {
            do {
                products = try await repository.fetchProducts(limit: limit, skip: skip)
                skip += limit
                showErrorMessage = false
            } catch {
                showErrorMessage = true
            }
        }
    }
    
    func didTap(product: Product) -> Bool {
        do {
            return try repository.save(product: product)
        } catch {
            return false
        }
    }
    
    func dismissAlert() {
        showErrorMessage = false
    }
}
