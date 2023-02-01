import Foundation

struct Product: Identifiable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let thumbnail: URL?
    let stock: Int
    let quantity: Int
    
    init(
        id: Int,
        title: String,
        price: Double,
        thumbnail: URL?,
        stock: Int,
        quantity: Int
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.thumbnail = thumbnail
        self.stock = stock
        self.quantity = quantity
    }
}

extension Product {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var priceString: String {
        PriceFormatter.money(amount: price)
    }
}
