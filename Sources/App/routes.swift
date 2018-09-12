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
    let todos = router.grouped("todos") // Drouped "todos" endpoints
    let todo = todos.grouped(Todo.parameter) // Parameterized "todos" endpoints
    let secureTodos = todos.grouped(SecretMiddleware.self) // Secured "todos" endpoints by injecting `SecretMiddleware.self` type
    
    todos.get(use: todoController.index)
    todo.get(use: todoController.view)
    
    // Only this particular endpoint will require authentication
    todos.post(use: todoController.create) // will cause http://todobackend.com/specs/index.html?http://localhost:8080/todos to fail -> use `todos` to make tests pass
    
    todo.patch(use: todoController.update)
    todo.delete(use: todoController.delete)
    todos.delete(use: todoController.clear)
}
