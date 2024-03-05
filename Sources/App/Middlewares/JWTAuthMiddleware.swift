//
//  File.swift
//  
//
//  Created by Khawlah Khalid on 05/03/2024.
//

import JWT
import Vapor

struct JWTAuthMiddleware: AsyncRequestAuthenticator{
    func authenticate(request: Vapor.Request) async throws {
        try request.jwt.verify(as: AuthPayload.self)
    }
}
