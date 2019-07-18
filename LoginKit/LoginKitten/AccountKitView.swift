//
//  AccountKitController.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 12/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import AccountKit
import SwiftUI
import UIKit

struct AccountKitView : View {
    @Environment(\.loginMode) var mode: LoginKitty.Screen
    @EnvironmentObject var user: User

    private let accountKit = AccountKit(responseType: .accessToken)

    var body: some View {
        PresentationLink(destination:
        AccountKitController(kit: accountKit,
                             delegate: AccountKitControllerDelegate(user: self.user, mode: self.mode))) {
            HStack {
                Image("accountkit").resizable().frame(width: 28, height: 28)
                Text(mode.frameworkCTA)
                    + Text(" AccountKit").bold()
                Spacer()
            }
            .padding(10)
            .background(Color(red: 0, green: 153/255.0, blue: 225/255.0))
            .foregroundColor(Color.white)
        }
        .cornerRadius(6)
    }
}

struct AccountKitController : UIViewControllerRepresentable {
    let kit: AccountKit
    let delegate: AccountKitControllerDelegate

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = kit.viewControllerForPhoneLogin()
        controller.delegate = delegate
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}

class AccountKitControllerDelegate: NSObject, AKFViewControllerDelegate {
    private var user: User
    private let mode: LoginKitty.Screen
    init(user: User, mode: LoginKitty.Screen) {
        self.user = user
        self.mode = mode
    }
    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith accessToken: AccessToken, state: String) {
        switch mode {
        case .signin: self.user.signin(source: .accountKit, token: accessToken.tokenString)
        case .signup: self.user.signup(source: .accountKit, token: accessToken.tokenString)
        default: break
        }
    }

    func viewController(_ viewController: UIViewController & AKFViewController, didFailWithError error: Error) {

    }
}
