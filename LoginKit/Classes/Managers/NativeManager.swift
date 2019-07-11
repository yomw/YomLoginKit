//
//  NativeSignin.swift
//  YomLoginKit
//
//  Created by Guillaume Bellue on 09/07/2019.
//

import AnimatedField

class NativeManager: NSObject, SigninManager, AnimatedFieldDelegate, AnimatedFieldDataSource {
    var parent: UIViewController?
    var signedUser: ((User) -> Void)?
    var cancelled: (() -> Void)?
    var resetPassword: (() -> Void)?

    private var formView: UIView?
    private var ctaButton: UIButton?
    private let title: String
    private let resetable: Bool

    private var formEmail: AnimatedField?
    private var formPassword: AnimatedField?

    var views: [UIView] {
        return resetable
            ? [buildFormView(), buildCTAView(), buildResetView()]
            : [buildFormView(), buildCTAView()]
    }

    init(title: String, resetable: Bool) {
        self.title = title
        self.resetable = resetable
        super.init()
    }

    func addError(_ message: String, on field: Field) {
        switch field {
        case .email:
            formEmail?.showAlert(message)
        case .password:
            formPassword?.showAlert(message)
        default:
            break
        }
    }

    func reset() {
        formEmail?.restart()
        formPassword?.restart()
    }

    private func buildFormView() -> UIView {
        if let formView = formView {
            return formView
        }

        let container = UIView()
        container.backgroundColor = .clear

        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.axis = .vertical
        container.addSubview(stack, withInsets: .zero)

        let email = AnimatedField()
        email.delegate = self
        email.dataSource = self
        email.type = .email
        email.placeholder = Strings.Placeholder.email
        email.format.countDown = false
        email.translatesAutoresizingMaskIntoConstraints = false
        email.heightAnchor.constraint(equalToConstant: 54).isActive = true
        stack.addArrangedSubview(email)

        let password = AnimatedField()
        password.delegate = self
        password.dataSource = self
        password.type = .password(0, 32)
        password.placeholder = Strings.Placeholder.password
        password.isSecure = true
        password.showVisibleButton = true
        password.format.countDown = false
        password.translatesAutoresizingMaskIntoConstraints = false
        password.heightAnchor.constraint(equalToConstant: 54).isActive = true
        stack.addArrangedSubview(password)

        formEmail = email
        formPassword = password
        formView = container

        return container
    }

    private func buildCTAView() -> UIView {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(act), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexString: "007AFF").cgColor
        button.layer.cornerRadius = 6
        ctaButton = button
        return button
    }

    private func buildResetView() -> UIView {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .right
        button.setTitle(Strings.Signin.reset, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(openReset), for: .touchUpInside)
        return button
    }

    @objc private func act() {
        let email = validateEmail()
        let password = validatePassword()
        guard email && password else {
            return
        }
        signedUser?(User(source: .native, email: formEmail?.text, password: formPassword?.text))
        _ = formEmail?.resignFirstResponder()
        _ = formPassword?.resignFirstResponder()
    }

    @objc private func openReset() {
        resetPassword?()
    }
    
    private func validateField(field: AnimatedField?, name: String) -> Bool {
        guard let field = field else { return true }
        if field.text?.isEmpty != false {
            field.showAlert(Strings.Error.empty(name))
            return false
        }
        if !field.isValid {
            field.showAlert(Strings.Error.invalid(name))
            return false
        }
        field.hideAlert()
        return true
    }

    private func validateEmail() -> Bool {
        return validateField(field: formEmail, name: Strings.Placeholder.email)
    }

    private func validatePassword() -> Bool {
        return validateField(field: formPassword, name: Strings.Placeholder.password)
    }

    func animatedFieldDidBeginEditing(_ animatedField: AnimatedField) {
        animatedField.hideAlert()
    }

    func animatedFieldShouldReturn(_ animatedField: AnimatedField) -> Bool {
        switch animatedField {
        case formEmail:
            _ = formPassword?.becomeFirstResponder()
        case formPassword:
            _ = formPassword?.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
