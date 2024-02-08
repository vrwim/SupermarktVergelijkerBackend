//
//  CreateStore.swift
//
//
//  Created by Wim Van Renterghem on 07/02/2024.
//

import Fluent
import Vapor

struct CreateStore: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("stores") // The table name should match the schema name in your Store model
            .id()
            .field("name", .string, .required)
            // Assuming locations and brands are stored as JSON arrays
            // This approach requires your database to support JSON or JSONB types
            .field("locations", .array(of: .string), .required)
            .field("brands", .array(of: .string), .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("stores").delete()
    }
}

