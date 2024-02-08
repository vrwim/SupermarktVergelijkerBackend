//
//  Product.swift
//  
//
//  Created by Wim Van Renterghem on 07/02/2024.
//

import Vapor
import Fluent

final class Product: Model, Content {
    static let schema = "products"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    // Add a property for the foreign key relation
    @Parent(key: "store_id")
    var store: Store
    
    @Field(key: "brand")
    var brand: String
    
    @Field(key: "location")
    var location: String

    @Field(key: "type")
    var type: String

    @Field(key: "size")
    var size: String

    @Field(key: "full_price")
    var fullPrice: Double

    @Field(key: "price_per_unit")
    var pricePerUnit: Double
    
    init() {}
    
    // Define an initializer that matches your Dart model
    init(id: UUID? = nil, name: String, store: Store, brand: String, location: String, type: String, size: String, fullPrice: Double, pricePerUnit: Double) {
        self.id = id
        self.name = name
        self.store = store
        self.brand = brand
        self.location = location
        self.type = type
        self.size = size
        self.fullPrice = fullPrice
        self.pricePerUnit = pricePerUnit
    }
}
