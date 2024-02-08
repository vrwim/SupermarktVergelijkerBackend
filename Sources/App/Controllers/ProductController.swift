//
//  ProductController.swift
//
//
//  Created by Wim Van Renterghem on 07/02/2024.
//

import Fluent
import Vapor

struct ProductController {
    func getProductSuggestions(req: Request) throws -> EventLoopFuture<[ProductSuggestion]> {
        let searchQuery = try req.query.get(String.self, at: "query")
        
        return Product.query(on: req.db)
            .filter(\.$name, .custom("ILIKE"), "%\(searchQuery)%") // Adjust based on your DB's case-insensitive search
            .with(\.$store) // Assuming a relation is defined; adjust as needed
            .all()
            .flatMap { products in
                // Group by product name
                let groupedProducts = Dictionary(grouping: products, by: { $0.name })
                
                // Construct ProductSuggestion for each group
                let suggestions = groupedProducts.map { name, products -> ProductSuggestion in
                    let stores = Array(Set(products.compactMap { $0.store })) // Assuming store is a related object
                    let types = Array(Set(products.compactMap { $0.type }))
                    let sizes = Array(Set(products.compactMap { $0.size }))
                    
                    return ProductSuggestion(name: name, stores: stores, types: types, sizes: sizes)
                }
                
                return req.eventLoop.future(suggestions)
            }
    }
    
    func getProducts(req: Request) throws -> EventLoopFuture<[ProductResponse]> {
        // Attempt to decode the query from the request's URL query string
        let query = try req.query.decode(ProductQuery.self)
        
        // Use the decoded query to filter products in your database
        // This is a simplified example; you'll need to adjust it based on your actual database schema and query capabilities
        return Product.query(on: req.db)
            .with(\Product.$store)
            .group(.and) { and in
                if let productName = query.productName {
                    and.filter(\.$name == productName)
                }
                if let storeId = query.storeId {
                    // Assuming the foreign key in Product is `store_id`
                    and.filter(\.$store.$id == UUID(storeId)!) // Cast the string to UUID
                }
                if let brand = query.brand {
                    and.filter(\.$brand == brand)
                }
                if let location = query.storeLocation {
                    and.filter(\.$location == location)
                }
                if let type = query.type {
                    and.filter(\.$type == type)
                }
                if let size = query.size {
                    and.filter(\.$size == size)
                }
            }
            .sort(\.$pricePerUnit, .ascending)
            .all()
            .map { products in
                return products.map { product in
                    return ProductResponse(from: product)
                }
            }
    }
}

struct ProductQuery: Content {
    var productName: String?
    var storeId: String?
    var storeLocation: String?
    var brand: String?
    var type: String?
    var size: String?
}

struct ProductResponse: Content {
    var id: UUID?
    var name: String
    var store: String
    var storeId: UUID?
    var brand: String
    var location: String
    var type: String
    var size: String
    var fullPrice: Double
    var pricePerUnit: Double
    
    init(from product: Product) {
        self.id = product.id
        self.name = product.name
        self.store = product.store.name
        self.storeId = product.store.id
        self.brand = product.brand
        self.location = product.location
        self.type = product.type
        self.size = product.size
        self.fullPrice = product.fullPrice
        self.pricePerUnit = product.pricePerUnit
    }
}
