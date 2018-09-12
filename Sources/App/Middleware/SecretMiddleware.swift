//
//  SecretMiddleware.swift
//  App
//
//  Created by Prochazka, Pavel on 12/09/2018.
//

import Vapor

final class SecretMiddleware: Middleware, Service {
    
    let secret: String
    
    // Secret is passed in `Environment variable`
    init(secret: String) {
        self.secret = secret
    }
    
    /// Test by: `curl -X POST -H 'Authorization:Bearer secret' localhost:8080/todos` will report missing content (`{"error":true,"reason":"Request does not have a content type."}%`)
    func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        guard let auth = req.http.headers.firstValue(name: .authorization) else {
            throw Abort.init(.unauthorized, reason: "Please include the Authorization header.")
        }
        guard auth == secret else {
            throw Abort.init(.unauthorized, reason: "Incorrect secret.")
        }
        return try next.respond(to: req)
    }
}
