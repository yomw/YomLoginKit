//
//  User.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 09/07/2019.
//

public struct User {
    public var token: String?
    public var email: String?
    public var password: String?
    public var source: LoginType

    init(source: LoginType, token: String? = nil, email: String? = nil, password: String? = nil) {
        self.source = source
        self.token = token
        self.email = email
        self.password = password
    }
}
