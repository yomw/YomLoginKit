//
//  ResetController.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 10/07/2019.
//

import AnimatedField

class ResetController: UIViewController, LoginKitController {
    var delegate: LoginDelegate = DefaultDelegate()
    var dataSource: LoginDataSource = DefaultDataSource()

    private let email = AnimatedField()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hexString: "FAFAFA")

        title = Strings.Reset.title
        buildForm()

        let closeButton = UIBarButtonItem(title: Strings.Common.close, style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }

    @objc private func close() {
        dismiss(animated: true)
    }

    private func buildForm() {
        let form = UIStackView()
        form.axis = .vertical
        form.spacing = 20
        var insets = UIEdgeInsets.zero
        if #available(iOS 11, *) { insets = view.safeAreaInsets }
        insets.left = 16
        insets.right = 16
        view.addSubview(form, withInsets: insets)

        form.addArrangedSubview(UIView())

        email.type = .email
        email.placeholder = Strings.Placeholder.reset
        email.format.countDown = false
        email.translatesAutoresizingMaskIntoConstraints = false
        email.heightAnchor.constraint(equalToConstant: 54).isActive = true
        form.addArrangedSubview(email)

        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(act), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexString: "007AFF").cgColor
        button.layer.cornerRadius = 6
        form.addArrangedSubview(button)

        form.addArrangedSubview(UIView())
    }

    @objc private func act() {
        _ = email.resignFirstResponder()
        guard email.isValid == true else {
            return
        }
        delegate.reset(user: User(source: .native, email: email.text))
    }

    func addError(_ message: String, on field: Field) {
        guard field == .email else { return }
        email.showAlert(message)
    }
}
