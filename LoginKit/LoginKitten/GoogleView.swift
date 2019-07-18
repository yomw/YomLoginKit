//
//  GoogleManager.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 15/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import GoogleSignIn
import SwiftUI

struct GoogleView: View {
    @Environment(\.loginMode) var mode: LoginKitty.Screen
    @EnvironmentObject var user: User

    var body: some View {
        Button(action: {
            guard let clientID = Bundle.main.infoDictionary?["GoogleClientID"] as? String else {
                return
            }
            let delegate = GoogleDelegate(user: self.user, mode: self.mode)
            GIDSignIn.sharedInstance()?.clientID = clientID
            GIDSignIn.sharedInstance()?.delegate = delegate
            GIDSignIn.sharedInstance()?.uiDelegate = delegate
            GIDSignIn.sharedInstance()?.signIn()
        }, label: {
            HStack {
                Image("google").resizable().frame(width: 28, height: 28)
                Text(mode.frameworkCTA)
                    + Text(" Google").bold()
                Spacer()
            }
            .padding(10)
            .background(Color.white)
            .foregroundColor(Color(red: 68/255.0, green: 68/255.0, blue: 68/255.0))
        })
        .cornerRadius(6)
        .border(Color.gray, width: 1, cornerRadius: 6)
    }
}

class GoogleDelegate: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    private var user: User
    private let mode: LoginKitty.Screen
    init(user: User, mode: LoginKitty.Screen) {
        self.user = user
        self.mode = mode
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
//            addError(error.localizedDescription, on: .google)
            return
        }

        switch mode {
        case .signin: self.user.signin(source: .google, token: user.authentication.idToken)
        case .signup: self.user.signup(source: .google, token: user.authentication.idToken)
        default: break
        }
    }

    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        UIApplication.shared.windows.first?
            .rootViewController?.presentedViewController?
            .present(viewController, animated: true)
    }

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        UIApplication.shared.windows.first?
            .rootViewController?.presentedViewController?
            .dismiss(animated: true)
    }
}
