//
//  File.swift
//  
//
//  Created by Sergey Abrosov on 15.05.2024.
//

import Fluent
import Vapor

struct CreateUser1: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("login", .string, .required)
            .field("password", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("users").delete()
    }
    
}
