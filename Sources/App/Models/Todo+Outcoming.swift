//
//  Todo+Outcoming.swift
//  App
//
//  Created by Prochazka, Pavel on 12/09/2018.
//

import Vapor

extension Todo {
    
    // All are optional, as we can use PATCH request in the future
    struct Outcoming: Content {
        var id: Int?
        var title: String?
        var completed: Bool?
        var order: Int?
        var url: String
    }
    
    func makeOutcoming(with req: Request) -> Outcoming {
        let idString = id?.description ?? ""
        let url = req.baseUrl + idString
        return Outcoming(id: id, title: title, completed: completed, order: order, url: url)
    }
}

/// Making it asynchronous
extension Future where T == Todo {
    func makeOutcoming(with req: Request) -> Future<Todo.Outcoming> {
        return map { todo in
            return todo.makeOutcoming(with: req)
        }
    }
}
