//
//  File.swift
//  
//
//  Created by Khawlah Khalid on 05/03/2024.
//

import Fluent
struct UsersTableMigrationAction: AsyncMigration{
    func prepare(on database: Database) async throws {
       try await database.schema("users")
            .id()
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("users")
            .delete()
    }
}
