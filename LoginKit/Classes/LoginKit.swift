//
//  LoginKit.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 2 juil. 2019.
//  Copyright © 2019 Yom. All rights reserved.
//

import UIKit

public enum LoginType {
    case facebook, accountKit, native, google
}
public enum Field { case email, password, facebook, accountKit, google, other }

public protocol LoginDelegate: class {
    func signin(user: User)
    func signup(user: User)
    func reset(user: User)
    func cancel()
}

public protocol LoginDataSource: class {
    func loginTypes() -> [LoginType]
}

class DefaultDelegate: LoginDelegate {
    var loginTypes: [LoginType] { return [.native] }
    func signin(user: User) {}
    func signup(user: User) {}
    func reset(user: User) {}
    func cancel() {}
}

class DefaultDataSource: LoginDataSource {
    func loginTypes() -> [LoginType] {
        return [.native]
    }
}

public class LoginKit: NSObject {
    var controller: LoginKitController?
    public private (set) var navigationController: UINavigationController?

    public var delegate: LoginDelegate = DefaultDelegate() {
        didSet { controller?.delegate = delegate }
    }
    public var dataSource: LoginDataSource = DefaultDataSource() {
        didSet { controller?.dataSource = dataSource }
    }

    public func viewControllerForSignin() -> UIViewController {
        let controller = SigninController()
        controller.delegate = delegate
        controller.dataSource = dataSource
        let navigation = UINavigationController(rootViewController: controller)
        if #available(iOS 11, *) {
            navigation.navigationBar.prefersLargeTitles = true
        }
        navigation.navigationBar.isTranslucent = false
        self.navigationController = navigation
        self.controller = controller

        return navigation
    }

    public func viewControllerForSignup() -> UIViewController {
        let controller = SignupController()
        controller.delegate = delegate
        controller.dataSource = dataSource
        let navigation = UINavigationController(rootViewController: controller)
        if #available(iOS 11, *) {
            navigation.navigationBar.prefersLargeTitles = true
        }
        navigation.navigationBar.isTranslucent = false
        self.navigationController = navigation
        self.controller = controller

        return navigation
    }

    public func addError(_ message: String, on field: Field) {
        let topMostHandler = navigationController?.viewControllers.compactMap { $0 as? LoginKitController }.last
        topMostHandler?.addError(message, on: field)
    }
}

protocol LoginKitController {
    func addError(_ message: String, on field: Field)
    var delegate: LoginDelegate { get set }
    var dataSource: LoginDataSource { get set }
}
