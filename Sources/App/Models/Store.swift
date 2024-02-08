//
//  Store.swift
//  
//
//  Created by Wim Van Renterghem on 07/02/2024.
//

import Vapor
import Fluent

final class Store: Model, Content, Hashable {
    static let schema = "stores"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String

    // Assuming locations and brands are stored as JSON arrays in the database
    // This approach requires your database to support storing JSON or JSONB and Vapor's Fluent to handle it
    @Field(key: "locations")
    var locations: [String]

    @Field(key: "brands")
    var brands: [String]
    
    init() {}
    
    init(id: UUID? = nil, name: String, locations: [String], brands: [String]) {
        self.id = id
        self.name = name
        self.locations = locations
        self.brands = brands
    }
    
    static func == (lhs: Store, rhs: Store) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
