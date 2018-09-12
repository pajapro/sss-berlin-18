import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    struct JSONExample: Content {
        let name: String
        let age: Int
        let birthday: Date
    }
    
    router.get("json") { _ in
        return JSONExample(
            name: "Hello",
            age: 1,
            birthday: Date()
        )
    }

    // Example of configuring a controller
    let todoController = TodoController()
    let todos = router.grouped("todos") // grouped "todos" endpoints
    let todo = todos.grouped(Todo.parameter) // parameterized "todos" endpoints
    let secureTodos = todos.grouped(SecretMiddleware.self) // secured "todos" endpoints by injecting `SecretMiddleware.self` type
    
    todos.get(use: todoController.index)
    todo.get(use: todoController.view)
    secureTodos.post(use: todoController.create)
    todo.patch(use: todoController.update)
    todo.delete(use: todoController.delete)
    todos.delete(use: todoController.clear)
}
