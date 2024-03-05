//
//  File.swift
//  
//
//  Created by Khawlah Khalid on 05/03/2024.
//

import Fluent
import Vapor
final class User: Content, Model{
    static var schema: String = "users"
    
    @ID()
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "name")
    var name: String
    
    init() { }
    
    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}

struct LoginRequest: Content{
    let email: String
    let password: String
}
