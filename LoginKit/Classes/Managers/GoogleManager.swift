//
//  GoogleManager.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 11/07/2019.
//

import GoogleSignIn

class GoogleManager: NSObject, SigninManager, GIDSignInDelegate, GIDSignInUIDelegate {
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
        button.backgroundColor = UIColor.white
        let gray = UIColor(hexString: "444444")
        let attributedString = NSMutableAttributedString(string: title, attributes: [.foregroundColor: gray])
        let range = (title as NSString).range(of: "Google")
        if range.location != NSNotFound {
            let font = UIFont.systemFont(ofSize: button.titleLabel?.font.pointSize ?? 17, weight: .bold)
            attributedString.addAttribute(.font, value: font, range: range)
        }
        button.setAttributedTitle(attributedString, for: .normal)
        button.setImage(Images.google, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 20)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(act), for: .touchUpInside)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1.0 / UIScreen.main.scale
        button.layer.borderColor = gray.cgColor
        ctaView = button
        return button
    }

    @objc private func act() {
        guard let clientID = Bundle.main.infoDictionary?["GoogleClientID"] as? String else {
            return
        }
        GIDSignIn.sharedInstance()?.clientID = clientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            addError(error.localizedDescription, on: .google)
            return
        }
        signedUser?(User(source: .google, token: user.authentication.idToken))
    }

    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        parent?.present(viewController, animated: true)
    }

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        parent?.dismiss(animated: true)
    }

    func addError(_ message: String, on field: Field) {
        guard field == .google else { return }
        let alert = UIAlertController(title: Strings.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Common.ok, style: .default))
        parent?.present(alert, animated: true)
    }
}
