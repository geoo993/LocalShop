@testable import LocalShop

extension PersistenceContextProviding {
    static func mock() -> Self {
        var values = [Product]()
        return .init {
            values
        } isSaved: { product in
            values.contains(where: { $0.id == product.id })
        } save: { product in
            values.append(product)
        } delete: { product in
            if let index = values.firstIndex(of: product) {
                values.remove(at: index)
            }
        }
    }
}
