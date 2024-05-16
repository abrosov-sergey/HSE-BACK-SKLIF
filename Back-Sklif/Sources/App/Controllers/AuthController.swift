//
//  AuthController.swift
//
//
//  Created by Sergey Abrosov on 01.05.2024.
//

import Foundation
import Fluent
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        usersGroup.post(use: createUser)
        usersGroup.get(use: getAllUsers)
        usersGroup.post("authorization", use: authUser)
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
    
    func authUser(_ req: Request) async throws -> User {
        
        struct UserModel: Codable {
            let login: String
            let password: String
        }
        
        guard let byteBuffer = req.body.data else {
            throw Abort(.badRequest)
        }
        
        let user = try JSONDecoder().decode(UserModel.self, from: byteBuffer)

        let users = try await User.query(on: req.db).all()
        
        for userFromDB in users {
            if userFromDB.login == user.login && userFromDB.password == user.password {
                return userFromDB
            }
        }
        
        throw Abort(.badRequest)
    }
}
