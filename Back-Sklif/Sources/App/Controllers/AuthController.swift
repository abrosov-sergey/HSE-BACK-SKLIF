//
//  AuthController.swift
//
//
//  Created by Sergey Abrosov on 01.05.2024.
//

import Fluent
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        usersGroup.post(use: createUser)
        usersGroup.get(use: getAllUsers)
    }
    
    func createUser(_ req: Request) async throws -> User {
        
        guard let user = try? req.content.decode(User.self) else {
            throw Abort(.custom(code: 500, reasonPhrase: "Ошибка декодирования данных req в модель User"))
        }
        
        try await user.save(on: req.db)
        return user
    }
    
    func getAllUsers(_ req: Request) async throws -> [User] {
        let users = try await User.query(on: req.db).all()
        
        return users
    }
}
