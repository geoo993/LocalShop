import Foundation

public struct Product: Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let price: Double
    public let thumbnail: URL?
    
    init(id: Int, title: String, price: Double, thumbnail: URL?) {
        self.id = id
        self.title = title
        self.price = price
        self.thumbnail = thumbnail
    }
}
