//
//  File.swift
//  
//
//  Created by Khawlah Khalid on 25/01/2024.
//

import Foundation
import Vapor
import Fluent

final class Plant: Model, Content{

    static let schema: String = "plants"
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name : String
    
    init() {}
    init(id: UUID? = nil, name: String){
        self.id = id
        self.name = name
    }
    
}
