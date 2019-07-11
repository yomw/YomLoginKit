//
//  SigninManager.swift
//  YomLoginKit
//
//  Created by Guillaume Bellue on 09/07/2019.
//

protocol SigninManager: class {
    var parent: UIViewController? { get set }
    var views: [UIView] { get }
    var signedUser: ((User) -> Void)? { get set }
    var cancelled: (() -> Void)? { get set }
    func addError(_ message: String, on field: Field)
    func reset()
}

extension SigninManager {
    func addError(_ message: String, on field: Field) {
        let alert = UIAlertController(title: Strings.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Common.ok, style: .default))
        parent?.present(alert, animated: true)
    }
    func reset() {}
}
