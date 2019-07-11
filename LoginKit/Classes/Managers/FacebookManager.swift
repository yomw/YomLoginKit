//
//  FacebookSignin.swift
//  YomLoginKit
//
//  Created by Guillaume Bellue on 09/07/2019.
//

import FacebookLogin
import FBSDKLoginKit

class FacebookManager: NSObject, SigninManager {
    private var ctaView: UIView?
    private let title: String

    var parent: UIViewController?
    var signedUser: ((User) -> Void)?
    var cancelled: (() -> Void)?
    var views: [UIView] { return [buildCTAView()] }

    init(title: String) {
        self.title = title
        super.init()
    }

    private func buildCTAView() -> UIView {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 59.0/255, green: 89.0/255, blue: 152.0/255, alpha: 1)
        let attributedString = NSMutableAttributedString(string: title, attributes: [.foregroundColor: UIColor.white])
        let range = (title as NSString).range(of: "Facebook")
        if range.location != NSNotFound {
            let font = UIFont.systemFont(ofSize: button.titleLabel?.font.pointSize ?? 17, weight: .bold)
            attributedString.addAttribute(.font, value: font, range: range)
        }
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(act), for: .touchUpInside)
        ctaView = button
        return button
    }

    @objc private func act() {
        let loginManager = FBSDKLoginKit.LoginManager()
        loginManager.logIn(viewController: parent) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.addError(error.localizedDescription, on: .facebook)
            case .cancelled:
                self.cancelled?()
            case .success(_, _, let accessToken):
                self.signedUser?(User(source: .facebook, token: accessToken.tokenString))
            }
        }
    }

    func addError(_ message: String, on field: Field) {
        guard field == .facebook else { return }
        let alert = UIAlertController(title: Strings.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Common.ok, style: .default))
        parent?.present(alert, animated: true)
    }
}
