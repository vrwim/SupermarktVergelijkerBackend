//
//  CreateProduct.swift
//
//
//  Created by Wim Van Renterghem on 07/02/2024.
//

import Fluent
import Vapor

struct CreateProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products") // The table name should match the schema name in your Product model
            .id()
            .field("name", .string, .required)
            .field("store_id", .uuid, .required, .references("stores", "id", onDelete: .cascade)) // Add this line
            .field("brand", .string, .required)
            .field("type", .string, .required)
            .field("size", .string, .required)
            .field("full_price", .double, .required)
            .field("price_per_unit", .double, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products").delete()
    }
}
