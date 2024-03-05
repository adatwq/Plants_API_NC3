//
//  File.swift
//  
//
//  Created by Khawlah Khalid on 05/03/2024.
//
import Vapor
import JWT

struct AuthPayload: JWTPayload {
    var expiration: ExpirationClaim
    var userId: UUID

    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
