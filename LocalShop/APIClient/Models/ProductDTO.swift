import Foundation

extension APIClient {
    struct Products: Decodable {
        let data: [Product]
        let total: Int
        let skip: Int
    }
}

extension APIClient.Products {
    enum CodingKeys: String, CodingKey {
        case data = "products"
        case total, skip
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
