//
//  ContentView.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 12/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI
import Combine
import IHProgressHUD

struct ContentView: View {
    var body: some View {
        NavigationView {
            RootView()
                .background(Image("palm")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.2))
        }
    }
}

struct RootView: View {
    @State private var isUserLogged = false
    @State private var showResetAlert = false

    private var signedInLink: NavigationDestinationLink<InsideView>
    private var signedUpLink: NavigationDestinationLink<AvatarView>
    private var publisher: AnyPublisher<Void, Never>
    private let login = LoginKitty(start: .signin)

    init() {
        IHProgressHUD.set(defaultMaskType: .clear)
        IHProgressHUD.set(defaultStyle: .dark)

        let publisher = PassthroughSubject<Void, Never>()
        self.publisher = publisher.eraseToAnyPublisher()

        signedInLink = NavigationDestinationLink(InsideView(onDismiss: { publisher.send() }))
        signedUpLink = NavigationDestinationLink(AvatarView(login: login, onDismiss: { publisher.send() }))
    }

    var body: some View {
        VStack {
            HStack {
                Text(Strings.Signin.title)
                    .font(.largeTitle).fontWeight(.semibold)
                    .padding(.leading, 16)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                Spacer()
            }
            Spacer()
            Button(action: { self.showModal() }) {
                Text("Enter")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                .background(Color.white)
                .cornerRadius(5)
                .border(Color.blue, width: 1, cornerRadius: 5)
            }
            Spacer().frame(height: 30)
        }
        .presentation($showResetAlert, alert: { () -> Alert in
            Alert(title: Text("Thank you. You will soon receive an email describing how to reset your password."),
                  dismissButton: .default(Text("OK")))
        })
        .onReceive(login.signinPublisher, perform: signin)
        .onReceive(login.signupPublisher, perform: signup)
        .onReceive(login.resetPublisher, perform: reset)
        .onReceive(publisher) { _ in
            self.signedInLink.presented?.value = false
            self.signedUpLink.presented?.value = false
        }
    }

    func showModal() {
        let window = UIApplication.shared.windows.first
        window?.rootViewController?.present(UIHostingController(rootView: login
            .environment(\.loginTypes, [.native, .accountKit, .facebook, .google])), animated: true)
    }
}

extension RootView {
    func signin(user: User) {
        print("DEBUG: Signin", user)
        IHProgressHUD.show(withStatus: "Loging in...")
        switch user.source {
        case .native:
            MockServer.signin(email: user.email, password: user.password, completion: signinResult)
        case .facebook:
            MockServer.signin(facebook: user.token, completion: signinResult)
        case .accountKit:
            MockServer.signin(accountKit: user.token, completion: signinResult)
        case .google:
            MockServer.signin(google: user.token, completion: signinResult)
        }
    }

    func signup(user: User) {
        UIApplication.shared.windows.first?
            .rootViewController?.dismiss(animated: true) {
                self.signedUpLink.presented?.value = true
        }
    }

    func reset(user: User) {
        IHProgressHUD.show(withStatus: "Sending request...")
        MockServer.reset(email: user.email, completion: resetResult)
        UIApplication.shared.windows.first?
            .rootViewController?.dismiss(animated: true)
    }

    private func signinResult(_ result: Result<Void, ServerError>) {
        IHProgressHUD.dismiss()
        switch result {
        case .failure(let error):
            login.addError(error.localizedDescription, on: error.field)
        case .success:
            dismiss { self.signedInLink.presented?.value = true }
        }
    }

    private func resetResult(_ result: Result<Void, ServerError>) {
        IHProgressHUD.dismiss()
        switch result {
        case .failure(let error):
            login.addError(error.localizedDescription, on: error.field)
        case .success:
            dismiss { self.showResetAlert.toggle() }
        }
    }

    private func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: completion)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, Locale(identifier: "fr"))
    }
}
#endif
