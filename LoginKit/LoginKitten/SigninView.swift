//
//  LoginKit.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 12/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI

struct SigninView: View {
    @Environment(\.isPresented) var isPresented
    @Environment(\.loginMode) var loginMode: LoginKitty.Screen
    @Environment(\.loginTypes) var loginTypes: [LoginType]

    @EnvironmentObject var user: User

    var body: some View {
        return VStack {
            Divider()
            VStack {
                if loginTypes.contains(.native) {
                    NativeFormView()
                    HStack {
                        Spacer()
                        NavigationLink(Strings.Signin.reset, destination: ResetView()
                            .environment(\.loginMode, .reset)
                            .environmentObject(user))
                    }

                    if loginTypes.count > 1 {
                        SeparatOr()
                    }
                }
                if loginTypes.contains(.facebook) { FacebookView() }
                if loginTypes.contains(.accountKit) { AccountKitView() }
                if loginTypes.contains(.google) { GoogleView() }
                Spacer()
                NavigationLink(Strings.Signin.signup, destination: SignupView()
                    .environment(\.loginMode, .signup)
                    .environmentObject(user))
                    .padding().padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
        .environment(\.loginMode, .signin)
        .navigationBarTitle(Text(loginMode.title))
        .background(Color(red: 250/255.0, green: 250/255.0, blue: 250/255.0))
        .edgesIgnoringSafeArea(.bottom)
    }
}

#if DEBUG
struct SigninView_Previews : PreviewProvider {
    static var previews: some View {
        let login = LoginKitty(start: .signin)
            .environment(\.loginTypes, [.native, .accountKit, .facebook])
        return login
    }
}
#endif
