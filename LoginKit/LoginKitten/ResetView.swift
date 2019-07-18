//
//  ResetView.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 16/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI

struct ResetView : View {
    @State var email: String = ""
    @State var error: String = ""
    @Environment(\.loginMode) var loginMode: LoginKitty.Screen
    @EnvironmentObject var user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Divider()
            VStack {
                LabelTextField(label: Strings.Placeholder.reset, placeHolder: Strings.Placeholder.reset,
                               value: $email, error: $error, validation: { value in
                    return value.isEmpty ? Strings.Error.empty("Email") : nil })
                Spacer().frame(height: 20)
                Button(action: {
                    guard !self.email.isEmpty else { return }
                    self.user.reset(email: self.email)
                }) {
                    Text(loginMode.nativeCTA)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.vertical, 12)
                }.border(Color.blue, cornerRadius: 5)
                Spacer()
            }
            .padding(.horizontal)
        }
        .background(Color(red: 250/255.0, green: 250/255.0, blue: 250/255.0))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(Text(loginMode.title))
    }
}

#if DEBUG
struct ResetView_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView { ResetView()
            .environment(\.loginMode, .reset)
            .environmentObject(User())
        }
    }
}
#endif
