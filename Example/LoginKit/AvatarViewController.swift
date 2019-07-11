//
//  AvatarViewController.swift
//  LoginKit_Example
//
//  Created by Guillaume Bellue on 10/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import IHProgressHUD
import LoginKit
import UIKit

class AvatarViewController: UIViewController {
    var user: User?
    var login: LoginKit?

    var onSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Upload Avatar"
    }

    @IBAction func createAccount() {
        guard let user = user else { return }
        IHProgressHUD.show(withStatus: "Creating account...")
        switch user.source {
        case .native:
            MockServer.signup(email: user.email, password: user.password, completion: signupResult)
        case .facebook:
            MockServer.signup(facebook: user.token, completion: signupResult)
        case .accountKit:
            MockServer.signup(accountKit: user.token, completion: signupResult)
        case .google:
            MockServer.signup(google: user.token, completion: signupResult)
        }
    }

    internal func signupResult(_ result: Result<Void, ServerError>) {
        IHProgressHUD.dismiss()
        switch result {
        case .failure(let error):
            navigationController?.popViewController(animated: true)
            login?.addError(error.localizedDescription, on: error.field)
        case .success:
            onSuccess?()
        }
    }
}

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
}
