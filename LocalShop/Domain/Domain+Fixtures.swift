import Foundation

extension Product {
    static func fixture(
        id: Int = 213,
        title: String = "iPhone 9",
        price: Double = 24.5,
        thumbnail: URL? = URL(string: "https://i.dummyjson.com/data/products/1/thumbnail.jpg")
    ) -> Self {
        self.init(
            id: id,
            title: title,
            price: price,
            thumbnail: thumbnail
        )
    }
}
