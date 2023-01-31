import Foundation

protocol ProductsRepository {
    func fetchProducts(
        limit: Int,
        skip: Int
    ) async throws -> [Product]
    
    func cartProducts() throws -> [Product]
    func save(product: Product) throws
    func delete(product: Product) throws
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
    
    func save(product: Product) throws {
        guard try !context.isSaved(product) else { return }
        try context.save(product)
    }

    func delete(product: Product) throws {
        guard try context.isSaved(product) else { return }
        try context.delete(product)
    }
}
