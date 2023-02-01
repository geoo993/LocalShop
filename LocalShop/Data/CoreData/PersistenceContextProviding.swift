import Foundation

struct PersistenceContextProviding {
    let items: () throws -> [Product]
    let isSaved: (Product) throws -> (Bool)
    let save: (Product) throws -> ()
    let delete: (Product) throws -> ()
    let quantity: (_ product: Product, _ units: Int) throws -> ()
}

extension PersistenceContextProviding {
    static var live: Self {
        let context = PersistenceController.shared.container.viewContext
        return .init {
            let request = ProductItem.fetchRequest()
            let items = try context.fetch(request)
            return items.compactMap { Product(model: $0) }
        } isSaved: { product in
            let request = ProductItem.fetchRequest()
            let items = try context.fetch(request)
            return items.contains(where: { $0.id == product.id })
        } save: { product in
            let item = ProductItem(context: context)
            item.id = Int16(product.id)
            item.title = product.title
            item.price = product.price
            item.thumbnail = product.thumbnail?.absoluteString
            item.stock = Int32(product.stock)
            item.quantity = Int32(product.quantity)
            try context.save()
        } delete: { product in
            let request = ProductItem.fetchRequest()
            let items = try context.fetch(request)
            if let item = items.first(where: { $0.id == product.id }) {
                context.delete(item)
                try context.save()
            }
        } quantity: { product, units in
            let request = ProductItem.fetchRequest()
            let items = try context.fetch(request)
            if let item = items.first(where: { $0.id == product.id }) {
                item.quantity = Int32(units)
                try context.save()
            }
        }
    }
}
