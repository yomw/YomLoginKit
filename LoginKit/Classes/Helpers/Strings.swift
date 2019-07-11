//
//  Strings.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 11/07/2019.
//

internal enum Strings {
    internal enum Reset {
        // Password reset
        internal static let title = Strings.tr("Localizable", "LoginKit.Reset.title")
    }
    internal enum Signin {
        // Sign in
        internal static let title = Strings.tr("Localizable", "LoginKit.Signin.title")
        // Sign in
        internal static let native = Strings.tr("Localizable", "LoginKit.Signin.native")
        // Sign in with Facebook
        internal static let facebook = Strings.tr("Localizable", "LoginKit.Signin.facebook")
        // Sign in with AccountKit
        internal static let accountKit = Strings.tr("Localizable", "LoginKit.Signin.accountKit")
        // Create account
        internal static let signup = Strings.tr("Localizable", "LoginKit.Signin.signup")
        // I lost my password
        internal static let reset = Strings.tr("Localizable", "LoginKit.Signin.reset")
    }
    internal enum Signup {
        // Sign up
        internal static let title = Strings.tr("Localizable", "LoginKit.Signup.title")
        // Sign up
        internal static let native = Strings.tr("Localizable", "LoginKit.Signup.native")
        // Sign up with Facebook
        internal static let facebook = Strings.tr("Localizable", "LoginKit.Signup.facebook")
        // Sign up with AccountKit
        internal static let accountKit = Strings.tr("Localizable", "LoginKit.Signup.accountKit")
        // I already have an account
        internal static let signin = Strings.tr("Localizable", "LoginKit.Signup.signin")
    }
    internal enum Common {
        // close
        internal static let close = Strings.tr("Localizable", "LoginKit.Common.close")
        // OK
        internal static let ok = Strings.tr("Localizable", "LoginKit.Common.ok")
        // Error
        internal static let error = Strings.tr("Localizable", "LoginKit.Common.error")
        // or
        internal static let or = Strings.tr("Localizable", "LoginKit.Common.or")
    }
    internal enum Placeholder {
        // Email
        internal static let reset = Strings.tr("Localizable", "LoginKit.Placeholder.reset")
        // Password
        internal static let password = Strings.tr("Localizable", "LoginKit.Placeholder.password")
        // Email
        internal static let email = Strings.tr("Localizable", "LoginKit.Placeholder.email")
    }
    internal enum Error {
        // <name> cannot be empty
        internal static func empty(_ field: String) -> String {
            return Strings.tr("Localizable", "LoginKit.Placeholder.empty", field)
        }
        // <name> is  not valid
        internal static func invalid(_ field: String) -> String {
            return Strings.tr("Localizable", "LoginKit.Placeholder.invalid", field)
        }
    }
}

extension Strings {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let mainBundleFormat = NSLocalizedString(key, comment: "")
        if mainBundleFormat != key {
            return String(format: mainBundleFormat, locale: Locale.current, arguments: args)
        }

        guard let bundlePath = Bundle(for: BundleToken.self).path(forResource: "LoginKit", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath) else {
            return key
        }
        let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

class BundleToken {}
