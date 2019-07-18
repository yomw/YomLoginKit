//
//  AvatarView.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 18/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI
import Combine
import IHProgressHUD

struct AvatarView : View {
    let login: LoginKitty
    var onDismiss: () -> Void

    private var signedInLink: NavigationDestinationLink<InsideView>
    private var publisher: AnyPublisher<Void, Never>

    init(login: LoginKitty, onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
        self.login = login
        let publisher = PassthroughSubject<Void, Never>()
        self.publisher = publisher.eraseToAnyPublisher()

        signedInLink = NavigationDestinationLink(InsideView(onDismiss: { publisher.send() }))
    }

    var body: some View {
        VStack {
            Divider()
            HStack { Spacer() }
            Spacer()
            Image("avatar")
                .resizable()
                .frame(width: 180, height: 180, alignment: .center)
            Spacer().frame(height: 60)
            Button("Create account") {
                self.createAccount()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .cornerRadius(6)
            .border(Color.blue, width: 1, cornerRadius: 6)
            Spacer()
        }
        .background(Color(red: 250/255.0, green: 250/255.0, blue: 250/255.0))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text("Upload Avatar"))
        .onReceive(publisher) { _ in
            self.signedInLink.presented?.value = false
        }
    }

    func createAccount() {
        IHProgressHUD.show(withStatus: "Creating account...")
        switch login.user.source {
        case .native:
            MockServer.signup(email: login.user.email, password: login.user.password, completion: signupResult)
        case .facebook:
            MockServer.signup(facebook: login.user.token, completion: signupResult)
        case .accountKit:
            MockServer.signup(accountKit: login.user.token, completion: signupResult)
        case .google:
            MockServer.signup(google: login.user.token, completion: signupResult)
        }
    }

    private func signupResult(_ result: Result<Void, ServerError>) {
        IHProgressHUD.dismiss()
        switch result {
        case .failure(let error):
            self.onDismiss()
            login.addError(error.localizedDescription, on: error.field)
        case .success:
            self.signedInLink.presented?.value = true
        }
    }
}

#if DEBUG
struct AvatarView_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView { AvatarView(login: LoginKitty(start: .signin), onDismiss: {}) }
    }
}
#endif
