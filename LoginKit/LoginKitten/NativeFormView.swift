//
//  NativeManager.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 15/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI

struct NativeFormView : View {
    @State var email: String = ""
    @State var emailError: String = ""
    @State var password: String = ""
    @State var passwordError: String = ""

    @EnvironmentObject var user: User
    @Environment(\.loginMode) var mode: LoginKitty.Screen

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            LabelTextField(label: Strings.Placeholder.email, placeHolder: Strings.Placeholder.email,
                           value: $email, error: $emailError, validation: { value in
                return value.isEmpty ? Strings.Error.empty("Email") : nil })
            LabelTextField(label: Strings.Placeholder.password, placeHolder: Strings.Placeholder.password,
                           value: $password, error: $passwordError)
            Spacer().frame(height: 20)
            Button(action: {
                guard !self.email.isEmpty, !self.password.isEmpty else { return }
                switch self.mode {
                case .signin: self.user.signin(source: .native, email: self.email, password: self.password)
                case .signup: self.user.signup(source: .native, email: self.email, password: self.password)
                default: break
                }
            }) {
                Text(mode.nativeCTA)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 12)
            }.border(Color.blue, cornerRadius: 5)
            Spacer().frame(height: 20)
        }
        .onReceive(user.didChange) { _ in
            self.user.errors?.forEach { field, error in
                switch field {
                case .email: self.emailError = error
                case .password: self.passwordError = error
                default: break
                }
            }
        }
    }
}

#if DEBUG
struct NativeManager_Previews : PreviewProvider {
    @State static var email: String = ""
    static var previews: some View {
        NativeFormView()
            .environment(\.loginMode, .signin)
//            .environment(\.locale, Locale(identifier: "fr"))
    }
}
#endif
