//
//  File.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 12/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI
import Combine

public enum LoginType {
    case facebook, accountKit, native
    case google // doesn't work for now
}
public enum Field { case email, password, facebook, accountKit, google, other }

public class User: BindableObject {
    public var didChange = PassthroughSubject<Void, Never>()

    var didSignin = PassthroughSubject<Void, Never>()
    var didSignup = PassthroughSubject<Void, Never>()
    var didReset = PassthroughSubject<Void, Never>()

    var source: LoginType = .native
    var email: String?
    var password: String?
    var token: String?

    var errors: [Field: String]? {
        didSet { didChange.send() }
    }

    public func signin(source: LoginType, token: String? = nil, email: String? = nil, password: String? = nil) {
        errors = nil
        self.source = source
        self.token = token
        self.email = email
        self.password = password
        didSignin.send()
    }

    public func signup(source: LoginType, token: String? = nil, email: String? = nil, password: String? = nil) {
        errors = nil
        self.source = source
        self.token = token
        self.email = email
        self.password = password
        didSignup.send()
    }

    public func reset(email: String) {
        errors = nil
        self.source = .native
        self.token = nil
        self.email = email
        self.password = nil
        didReset.send()
    }

    func reset() -> Self {
        errors = nil
        source = .native
        token = nil
        email = nil
        password = nil
        didSignin = PassthroughSubject<Void, Never>()
        didSignup = PassthroughSubject<Void, Never>()
        didReset = PassthroughSubject<Void, Never>()
        return self
    }
}

public class DataSource: BindableObject {
    public var didChange = PassthroughSubject<Void, Never>()

    public var loginTypes: [LoginType] = [.native, .accountKit, .facebook] {
        didSet { didChange.send() }
    }
}

public struct LoginKitty: View {
    enum Screen {
        case signin, signup, reset
        var title: LocalizedStringKey {
            switch self {
            case .signin: return Strings.Signin.title
            case .signup: return Strings.Signup.title
            case .reset: return Strings.Reset.title
            }
        }
        var nativeCTA: LocalizedStringKey {
            return title
        }
        var frameworkCTA: LocalizedStringKey {
            switch self {
            case .signin: return Strings.Signin.using
            case .signup: return Strings.Signup.using
            case .reset: return Strings.Reset.title
            }
        }
    }

    var signinPublisher = PassthroughSubject<User, Never>()
    var signupPublisher = PassthroughSubject<User, Never>()
    var resetPublisher = PassthroughSubject<User, Never>()

    private let startScreen: Screen
    let user = User()

    init(start: Screen) {
        startScreen = start
    }

    public var body: some View {
        NavigationView {
            if startScreen == .signin {
                SigninView()
            } else {
                SignupView()
            }
        }
        .environment(\.loginMode, startScreen)
        .environmentObject(user.reset())
        .onReceive(user.didSignin, perform: { _ in
            self.signinPublisher.send(self.user) })
        .onReceive(user.didSignup, perform: { _ in
            self.signupPublisher.send(self.user) })
        .onReceive(user.didReset, perform: { _ in
            self.resetPublisher.send(self.user) })
    }

    public func addError(_ message: String, on field: Field) {
        user.errors = [field: message]
    }
}

struct LoginModeKey: EnvironmentKey {
    static let defaultValue: LoginKitty.Screen = .signin
}

struct LoginTypesKey: EnvironmentKey {
    static let defaultValue: [LoginType] = [.native]
}

extension EnvironmentValues {
    var loginMode: LoginKitty.Screen {
        get { return self[LoginModeKey.self] }
        set { self[LoginModeKey.self] = newValue }
    }

    var loginTypes: [LoginType] {
        get { return self[LoginTypesKey.self] }
        set { self[LoginTypesKey.self] = newValue }
    }
}
