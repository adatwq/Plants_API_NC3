//
//  File.swift
//  
//
//  Created by Khawlah Khalid on 01/03/2023.
//

import Vapor
import Fluent

struct CreatePlantsTable: Migration{
    func prepare(on database: FluentKit.Database) -> EventLoopFuture<Void> {
        database.schema("plants")
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> EventLoopFuture<Void> {
        database.schema("plants")
            .delete()
    }
}

