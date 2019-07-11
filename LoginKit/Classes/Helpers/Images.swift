//
//  Images.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 11/07/2019.
//

internal enum Images {
    internal static let facebook = Images.loadImage(named: "facebook")
    internal static let accountKit = Images.loadImage(named: "accountkit")
    internal static let google = Images.loadImage(named: "google")
}

extension Images {
    private static func loadImage(named name: String) -> UIImage? {
        guard let bundlePath = Bundle(for: BundleToken.self).path(forResource: "LoginKit", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath) else {
                return nil
        }
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}
