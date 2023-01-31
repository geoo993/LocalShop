import Foundation

extension Product {
    init(model: APIClient.Product) {
        self.init(
            id: model.id,
            title: model.title,
            price: model.price,
            thumbnail: URL(string: model.thumbnail)
        )
    }
    
    init?(model: ProductItem) {
        guard let title = model.title, let thumbnail = model.thumbnail else {
            return nil
        }
        self.init(
            id: Int(model.id),
            title: title,
            price: model.price,
            thumbnail: URL(string: thumbnail)
        )
    }
}
