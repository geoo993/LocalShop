import Foundation

protocol ProductsRepository {
    func fetchProducts(
        limit: Int,
        skip: Int
    ) async throws -> [Product]
    
    func cartProducts() throws -> [Product]
    func save(product: Product) throws -> Bool
    func updateQuantity(of product: Product, units: Int) throws
}

struct DefaultProductsRepository: ProductsRepository {
    private let apiclient: APIClientRequestable
    private let context: PersistenceContextProviding

    init(
        apiclient: APIClientRequestable = APIClient(),
        context: PersistenceContextProviding = .live
    ) {
        self.apiclient = apiclient
        self.context = context
    }
    
    func fetchProducts(
        limit: Int,
        skip: Int
    ) async throws -> [Product] {
        try await apiclient
            .execute(request: FetchProductsRequest(limit: limit, skip: skip))
            .data.map(Product.init)
    }
    
    func cartProducts() throws -> [Product] {
        try context.items()
    }
    
    func save(product: Product) throws -> Bool {
        if try !context.isSaved(product) {
            try context.save(product)
            return true
        } else {
            try context.delete(product)
            return false
        }
    }
    
    func updateQuantity(of product: Product, units: Int) throws {
        guard try context.isSaved(product) else { return }
        if units == 0 {
            try context.delete(product)
        } else {
            try context.quantity(product, units)
        }
    }
}
