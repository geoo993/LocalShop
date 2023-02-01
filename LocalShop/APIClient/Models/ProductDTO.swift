import Foundation

extension APIClient {
    struct Products: Decodable {
        let data: [Product]
    }
}

extension APIClient.Products {
    enum CodingKeys: String, CodingKey {
        case data = "products"
    }
}

extension APIClient {
    struct Product: Decodable {
        let id: Int
        let title: String
        let price: Double
        let thumbnail: String
        let stock: Int
    }
}
