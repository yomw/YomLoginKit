//
//  SignupView.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 15/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI

struct SignupView : View {
    @Environment(\.isPresented) var isPresented
    @Environment(\.loginMode) var loginMode: LoginKitty.Screen
    @Environment(\.loginTypes) var loginTypes: [LoginType]

    @EnvironmentObject var user: User

    var body: some View {
        VStack {
            Divider()
            VStack {
                if loginTypes.contains(.native) {
                    NativeFormView()
                    if loginTypes.count > 1 {
                        SeparatOr()
                    }
                }
                if loginTypes.contains(.facebook) { FacebookView() }
                if loginTypes.contains(.accountKit) { AccountKitView() }
                if loginTypes.contains(.google) { GoogleView() }
                Spacer()
                NavigationLink(Strings.Signup.signin, destination: SigninView()
                    .environment(\.loginMode, .signin)
                    .environmentObject(user))
                    .padding().padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
        .environment(\.loginMode, .signup)
        .navigationBarTitle(Text(loginMode.title))
        .background(Color(red: 250/255.0, green: 250/255.0, blue: 250/255.0))
        .edgesIgnoringSafeArea(.bottom)
    }
}

#if DEBUG
struct SignupView_Previews : PreviewProvider {
    static var previews: some View {
        let login = LoginKitty(start: .signup)
            .environment(\.loginTypes, [.native, .accountKit, .facebook, .google])
        return login
    }
}
#endif
