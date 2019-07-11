//
//  ViewController.swift
//  LoginKit
//
//  Created by yomw on 07/09/2019.
//  Copyright (c) 2019 yomw. All rights reserved.
//

import UIKit
import LoginKit
import IHProgressHUD

class ViewController: UIViewController {
    let login = LoginKit()

    override func viewDidLoad() {
        super.viewDidLoad()

        IHProgressHUD.set(defaultMaskType: .clear)
        IHProgressHUD.set(defaultStyle: .dark)

        login.delegate = self
        login.dataSource = self
    }

    @IBAction func startSign() {
        present(login.viewControllerForSignin(), animated: true)
    }

    @IBAction func unwind(segue: UIStoryboardSegue) { }
}

extension ViewController: LoginDataSource {
    func loginTypes() -> [LoginType] {
        return [.native, .accountKit, .facebook]
    }
}

extension ViewController: LoginDelegate {
    func signin(user: User) {
        IHProgressHUD.show(withStatus: "Loging in...")
        switch user.source {
        case .native:
            MockServer.signin(email: user.email, password: user.password, completion: signinResult)
        case .facebook:
            MockServer.signin(facebook: user.token, completion: signinResult)
        case .accountKit:
            MockServer.signin(accountKit: user.token, completion: signinResult)
        }
    }

    func signup(user: User) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "AvatarViewController") as? AvatarViewController {
            controller.user = user
            controller.login = login
            controller.onSuccess = startApplication
            login.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func reset(user: User) {
        IHProgressHUD.show(withStatus: "Sending request...")
        MockServer.reset(email: user.email, completion: resetResult)
    }

    func cancel() {

    }
}

extension ViewController { // Mock results
    private func startApplication() {
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "StartApplication", sender: nil)
        }
    }

    private func signinResult(_ result: Result<Void, ServerError>) {
        IHProgressHUD.dismiss()
        switch result {
        case .failure(let error):
            login.addError(error.localizedDescription, on: error.field)
        case .success:
            startApplication()
        }
    }

    private func resetResult(_ result: Result<Void, ServerError>) {
        IHProgressHUD.dismiss()
        switch result {
        case .failure(let error):
            login.addError(error.localizedDescription, on: error.field)
        case .success:
            dismiss(animated: true) {
                let message = "Thank you. You will soon receive an email describing how to reset your password."
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
