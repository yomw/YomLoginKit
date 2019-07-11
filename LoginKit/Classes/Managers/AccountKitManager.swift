//
//  AccountKitSignin.swift
//  YomLoginKit
//
//  Created by Guillaume Bellue on 09/07/2019.
//

import AccountKit

class AccountKitManager: NSObject, SigninManager, AKFViewControllerDelegate {
    private var ctaView: UIView?
    private let accountKit: AccountKit
    private let title: String

    var parent: UIViewController?
    var signedUser: ((User) -> Void)?
    var cancelled: (() -> Void)?
    var views: [UIView] { return [buildCTAView()] }

    init(title: String) {
        self.title = title
        accountKit = AccountKit(responseType: .accessToken)
        super.init()
    }

    private func buildCTAView() -> UIView {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hexString: "0099E1")
        let attributedString = NSMutableAttributedString(string: title, attributes: [.foregroundColor: UIColor.white])
        let range = (title as NSString).range(of: "AccountKit")
        if range.location != NSNotFound {
            let font = UIFont.systemFont(ofSize: button.titleLabel?.font.pointSize ?? 17, weight: .bold)
            attributedString.addAttribute(.font, value: font, range: range)
        }
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(act), for: .touchUpInside)
        button.layer.cornerRadius = 6
        ctaView = button
        return button
    }

    @objc private func act() {
        let viewController = accountKit.viewControllerForPhoneLogin()
        viewController.delegate = self
        parent?.present(viewController, animated: true)
    }

    internal func viewController(_ viewController: UIViewController & AKFViewController,
                                 didCompleteLoginWith accessToken: AccessToken, state: String) {
        signedUser?(User(source: .accountKit, token: accessToken.tokenString))
    }

    func viewControllerDidCancel(_ viewController: UIViewController & AKFViewController) {
        cancelled?()
    }

    func viewController(_ viewController: UIViewController & AKFViewController, didFailWithError error: Error) {
        addError(error.localizedDescription, on: .accountKit)
    }

    func addError(_ message: String, on field: Field) {
        guard field == .accountKit else { return }
        let alert = UIAlertController(title: Strings.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Common.ok, style: .default))
        parent?.present(alert, animated: true)
    }
}
