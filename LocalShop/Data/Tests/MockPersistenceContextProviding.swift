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
        } quantity: { product, units in
            if let index = values.firstIndex(of: product) {
                let current = values[index]
                let item: Product = .init(
                    id: current.id,
                    title: current.title,
                    price: current.price,
                    thumbnail: current.thumbnail,
                    stock: current.stock,
                    quantity: units
                )
                values.remove(at: index)
                values.append(item)
            }
        }
    }
}
