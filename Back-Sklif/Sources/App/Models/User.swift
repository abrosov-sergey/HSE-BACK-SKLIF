//
//  File.swift
//  
//
//  Created by Sergey Abrosov on 01.05.2024.
//

import Fluent
import Vapor

final class User: Model, Content {
    
    static var schema: String = "users"
    
    @ID var id: UUID?
    @Field(key: "login") var login: String
    @Field(key: "password") var password: String
    
    init() {}
    
    internal init(id: UUID? = nil, login: String, password: String) {
        self.id = id
        self.login = login
        self.password = password
    }
}
