//
//  SigninController.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 09/07/2019.
//

class SigninController: UIViewController, LoginKitController {
    var delegate: LoginDelegate = DefaultDelegate()
    var dataSource: LoginDataSource = DefaultDataSource()

    private var loginTypes: [LoginType] = []
    private var managers: [SigninManager] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hexString: "FAFAFA")

        loginTypes = dataSource.loginTypes()
        if loginTypes.isEmpty {
            loginTypes = [.native]
        }

        title = Strings.Signin.title
        buildForm()
        addSignupButton()

        managers.forEach {
            $0.signedUser = self.signedUser
            $0.cancelled = self.cancelled
        }

        let closeButton = UIBarButtonItem(title: Strings.Common.close, style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }

    func reset() {
        managers.forEach { $0.reset() }
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

        if loginTypes.contains(.native) {
            let manager = NativeManager(title: Strings.Signin.native, resetable: true)
            manager.parent = self
            manager.resetPassword = openReset
            manager.views.forEach { form.addArrangedSubview($0) }
            managers.append(manager)

            if loginTypes.count > 1 {
                form.addArrangedSubview(separator())
            }
        }

        if loginTypes.contains(.facebook) {
            let manager = FacebookManager(title: Strings.Signin.facebook)
            manager.parent = self
            manager.views.forEach { form.addArrangedSubview($0) }
            managers.append(manager)
        }

        if loginTypes.contains(.accountKit) {
            let manager = AccountKitManager(title: Strings.Signin.accountKit)
            manager.parent = self
            manager.views.forEach { form.addArrangedSubview($0) }
            managers.append(manager)
        }

        form.addArrangedSubview(UIView())
    }

    private func separator() -> UIView {
        let container = UIView()

        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(line)
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            line.centerYAnchor.constraint(equalTo: container.centerYAnchor)])

        let label = UILabel()
        label.backgroundColor = view.backgroundColor
        label.textColor = UIColor.lightGray
        label.text = "    \(Strings.Common.or)    "
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),
            line.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)])

        return container
    }

    private func addSignupButton() {
        let button = UIButton(type: .system)
        button.setTitle(Strings.Signin.signup, for: .normal)
        button.addTarget(self, action: #selector(openSignup), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)])
        } else {
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)])
        }
    }

    @objc private func openSignup() {
        if let navigation = navigationController?.viewControllers,
            navigation.count > 1, navigation[navigation.count - 2] is SignupController {
            _ = navigationController?.popViewController(animated: true)
        } else {
            let controller = SignupController()
            controller.delegate = delegate
            controller.dataSource = dataSource
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    @objc private func openReset() {
        let controller = ResetController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }

    func addError(_ message: String, on field: Field) {
        managers.forEach { $0.addError(message, on: field) }
    }

    private func signedUser(_ user: User) {
        delegate.signin(user: user)
    }

    private func cancelled() {
        delegate.cancel()
    }
}
