//
//  MockServer.swift
//  LoginKit_Example
//
//  Created by Guillaume Bellue on 09/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import LoginKit

enum ServerError: Error, LocalizedError, CustomStringConvertible {
    var description: String {
        switch self {
        case .emailNotFound: return "Email not found"
        case .emailTaken: return "Email is already in use"
        case .emailMalformed: return "Email is not valid"
        case .emailMissing: return "Email is missing"
        case .passwordNotComplexEnough: return "Your password must contain 342 special characters, 527 numbers and %** uppercased characters"
        case .passwordTooShort: return "Password is too short"
        case .passwordMissing: return "Password is missing"
        }
    }
    var errorDescription: String? { return description }

    case emailNotFound, emailTaken, emailMalformed, emailMissing
    case passwordMissing, passwordTooShort, passwordNotComplexEnough

    var field: Field {
        switch self {
        case .emailNotFound, .emailTaken, .emailMalformed, .emailMissing: return .email
        case .passwordMissing, .passwordTooShort, .passwordNotComplexEnough: return .password
        }
    }
}

class MockServer {
    // SIGNIN
    static func signin(email: String?, password: String?, completion: @escaping (Result<Void, ServerError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if email == "fail@fail.me" {
                completion(.failure(ServerError.emailNotFound))
            } else {
                completion(.success(()))
            }
        }
    }
    static func signin(facebook: String?, completion: @escaping (Result<Void, ServerError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(()))
        }
    }
    static func signin(accountKit: String?, completion: @escaping (Result<Void, ServerError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(()))
        }
    }
    static func signin(google: String?, completion: @escaping (Result<Void, ServerError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(()))
        }
    }

    // SIGNUP
    static func signup(email: String?, password: String?, completion: @escaping (Result<Void, ServerError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if email == "fail@fail.me" {
                completion(.failure(ServerError.emailTaken))
            } else {
                completion(.success(()))
            }
        }
    }
    static func signup(facebook: String?, completion: @escaping (Result<Void, ServerError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(()))
        }
    }
    static func signup(accountKit: String?, completion: @escaping (Result<Void, ServerError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(()))
        }
    }
    static func signup(google: String?, completion: @escaping (Result<Void, ServerError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(()))
        }
    }

    // RESET
    static func reset(email: String?, completion: @escaping (Result<Void, ServerError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if email == "fail@fail.me" {
                completion(.failure(ServerError.emailNotFound))
            } else {
                completion(.success(()))
            }
        }
    }
}
