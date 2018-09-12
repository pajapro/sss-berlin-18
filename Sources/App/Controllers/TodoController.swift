import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo.Outcoming]> {
        return Todo.query(on: req).all().map { todos in
            return todos.map { todo in
                return todo.makeOutcoming(with: req)
            }
        }
    }
    
    func view(_ req: Request) throws -> Future<Todo.Outcoming> {
        return try req.parameters.next(Todo.self).makeOutcoming(with: req)
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo.Outcoming> {
        return try req.content.decode(Todo.Incoming.self).flatMap { todo in
            return todo.makeTodo().save(on: req)
        }.makeOutcoming(with: req)
    }
    
    // ❗️ combining 2 async requests into one
    func update(_ req: Request) throws -> Future<Todo.Outcoming> {
        let todo = try req.parameters.next(Todo.self)
        let incoming = try req.content.decode(Todo.Incoming.self)
        
        return flatMap(to: Todo.self, todo, incoming) { (todo, incoming) in
            return todo.patched(with: incoming).update(on: req)
        }.makeOutcoming(with: req)
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
    
    func clear(_ req: Request) throws -> Future<HTTPStatus> {
        return Todo.query(on: req).delete().transform(to: HTTPStatus.ok)
    }
}
