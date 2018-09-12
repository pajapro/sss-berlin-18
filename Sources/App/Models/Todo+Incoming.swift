//
//  Todo+Incoming.swift
//  App
//
//  Created by Prochazka, Pavel on 12/09/2018.
//

import Vapor

extension Todo {
    
    // All are optional, as we can use PATCH request in the future
    struct Incoming: Content {
        var title: String?
        var completed: Bool?
        var order: Int?
        
        // Factory to create empty incoming todo
        func makeTodo() -> Todo {
            return Todo(id: nil, title: title ?? "", completed: completed ?? false, order: order)
        }
    }
}
