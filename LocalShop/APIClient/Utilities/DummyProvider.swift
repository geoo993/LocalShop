import Foundation

protocol DummyProviding {
    associatedtype ResponseObject: Decodable
    static func dummy() throws -> Data
    static func fixture() throws -> ResponseObject
}

extension DummyProviding {
    static func dummy() throws -> Data {
        guard
            let url = Bundle.main.url(forResource: String(describing: self), withExtension: "json")
        else { throw APIError.unknown }
        return try Data(contentsOf: url)
    }
    
    static func fixture() throws -> ResponseObject {
        let data = try dummy()
        return try JSONDecoder().decode(ResponseObject.self, from: data)
    }
}

extension FetchProductsRequest: DummyProviding {}
