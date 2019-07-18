//
//  FacebookManager.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 15/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import FacebookLogin
import FBSDKLoginKit
import SwiftUI

struct FacebookView : View {
    @Environment(\.loginMode) var mode: LoginKitty.Screen
    @EnvironmentObject var user: User

    var body: some View {
        Button(action: {
            FBSDKLoginManager().logIn(withReadPermissions: nil, from: nil) { loginResult, error in
                guard let result = loginResult,
                    let token = result.token else {
                    if let error = error {
                        // nothing
                    }
                    return
                }
                switch self.mode {
                case .signin: self.user.signin(source: .facebook, token: token.tokenString)
                case .signup: self.user.signup(source: .facebook, token: token.tokenString)
                default: break
                }
            }
        }, label: {
            HStack {
                Image("facebook").resizable().frame(width: 28, height: 28)
                Text(mode.frameworkCTA)
                    + Text(" Facebook").bold()
                Spacer()
            }
            .padding(10)
            .background(Color(red: 59/255.0, green: 89/255.0, blue: 152/255.0))
            .foregroundColor(Color.white)

        })
        .cornerRadius(6)
    }
}
