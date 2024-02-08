//
//  CreateLocationColumn.swift
//
//
//  Created by Wim Van Renterghem on 08/02/2024.
//

import Fluent

struct CreateLocationColumn: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products") // Specify the table name
            .field("location", .string, .sql(.default("Oostende")))
            .update() // Use `.update()` to alter the table
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products")
            .deleteField("location") // Remove the newly added column on revert
            .update() // Apply the update
    }
}
