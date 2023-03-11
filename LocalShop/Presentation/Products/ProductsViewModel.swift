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
                let results = try await withThrowingTaskGroup(
                    of: Product.self,
                    returning: [Product].self,
                    body: { taskGroup in
                        let results = try await self.repository.fetchProducts(limit: self.limit, skip: self.skip)
                        self.skip += limit
                        return results
                })
                products.append(contentsOf: results)
                showErrorMessage = false
            } catch {
                showErrorMessage = true
            }
        }
    }
    
    @MainActor
    func loadNextProducts() {
        loadProducts()
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
