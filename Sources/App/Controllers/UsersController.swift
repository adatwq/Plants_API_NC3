//
//  File.swift
//
//
//  Created by Khawlah Khalid on 05/03/2024.
//

import Vapor
import Fluent

struct UsersController: RouteCollection{
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post("registration", use: registration)
        users.post("login", use: login)
    }
    
    //Add new user - Registration - POST
    func registration(req: Request) async throws -> User {
        let newUser = try  req.content.decode(User.self)
        //Check that email is unique
        let userInDB =  try await User.query(on: req.db)
            .filter(\.$email == newUser.email)
            .first()
        guard userInDB == nil else {
            throw Abort(.conflict, reason: "Email is already exist")
        }
        
        let hashedPasword = try req.password.hash(newUser.password)
        newUser.password = hashedPasword
        try await  newUser.create(on: req.db)
        return newUser
        
    }
    
    //Check if valid (exist) user - Login - POST
    func login(req: Request) async throws  -> [String: String]{
        let userAuth = try req.content.decode(LoginRequest.self)
        let userInDB = try await User.query(on: req.db)
            .filter(\.$email == userAuth.email)
            .first()
        
        guard let userInDB else {
            throw Abort(.notFound, reason: "Email is not exist")
        }
        
        let result = try req.password.verify(userAuth.password, created: userInDB.password)
        
        guard result else {
            throw Abort(.badRequest, reason: "Password is not correct")
        }
        let payload = AuthPayload(expiration: .init(value: .distantFuture), userId: try userInDB.requireID())

        return try [
            "token": req.jwt.sign(payload)
        ]
    }
}
