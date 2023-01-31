import Foundation

extension APIClient {
    public struct Products: Decodable {
        public let data: [Product]
    }
}

extension APIClient.Products {
    enum CodingKeys: String, CodingKey {
        case data = "products"
    }
}

extension APIClient {
    public struct Product: Decodable {
        public let id: Int
        public let title: String
        public let price: Double
        public let thumbnail: String
    }
}
