//
//  Strings.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 11/07/2019.
//

import Foundation
import SwiftUI

internal enum Strings {
    internal enum Reset {
        // Password reset
        internal static let title: LocalizedStringKey = "LoginKit.Reset.title"
    }
    internal enum Signin {
        // Sign in
        internal static let title: LocalizedStringKey = "LoginKit.Signin.title"
        // Sign in
        internal static let native: LocalizedStringKey = "LoginKit.Signin.native"
        // Sign in with
        internal static let using: LocalizedStringKey = "LoginKit.Signin.using"
        // Create account
        internal static let signup: LocalizedStringKey = "LoginKit.Signin.signup"
        // I lost my password
        internal static let reset: LocalizedStringKey = "LoginKit.Signin.reset"
    }
    internal enum Signup {
        // Sign up
        internal static let title: LocalizedStringKey = "LoginKit.Signup.title"
        // Sign up
        internal static let native: LocalizedStringKey = "LoginKit.Signup.native"
        // Sign up with
        internal static let using: LocalizedStringKey = "LoginKit.Signup.using"
        // I already have an account
        internal static let signin: LocalizedStringKey = "LoginKit.Signup.signin"
    }
    internal enum Common {
        // close
        internal static let close: LocalizedStringKey = "LoginKit.Common.close"
        // OK
        internal static let ok: LocalizedStringKey = "LoginKit.Common.ok"
        // Error
        internal static let error: LocalizedStringKey = "LoginKit.Common.error"
        // or
        internal static let or: LocalizedStringKey = "LoginKit.Common.or"
    }
    internal enum Placeholder {
        // Email
        internal static let reset: LocalizedStringKey = "LoginKit.Placeholder.reset"
        // Password
        internal static let password: LocalizedStringKey = "LoginKit.Placeholder.password"
        // Email
        internal static let email: LocalizedStringKey = "LoginKit.Placeholder.email"
    }
    internal enum Error {
        // <name> cannot be empty
        internal static func empty(_ field: String) -> String {
            return String(format: NSLocalizedString("LoginKit.Placeholder.empty", comment: ""), field)
        }
        // <name> is  not valid
        internal static func invalid(_ field: String) -> String {
            return String(format: NSLocalizedString("LoginKit.Placeholder.invalid", comment: ""), field)
        }
    }
}
