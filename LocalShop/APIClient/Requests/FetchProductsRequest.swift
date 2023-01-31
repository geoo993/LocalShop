import Foundation

struct FetchProductsRequest: HTTPRequest {
    typealias ResponseObject = APIClient.Products
    let path = "/products"
    let queryItems: [URLQueryItem]?
    
    init(limit: Int, skip: Int) {
        self.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)")
        ]
    }
}
