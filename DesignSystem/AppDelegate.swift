//
//  AppDelegate.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 12/07/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isLegacyMode: Bool = true

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        configureDesignSystem(with: window)

        window?.rootViewController = makePromoVC()
        window?.makeKeyAndVisible()

        return true
    }

    private func configureDesignSystem(with window: UIWindow?) {
        if isLegacyMode {
            loadInitialThemes()
            currentThemeDidChange()
        } else {
            DesignSystemEngine.configure(with: window)
        }
    }

    private func makePromoVC() -> UIViewController {
        if isLegacyMode {
            return UINavigationController(rootViewController: LegacyPromoViewController())
        } else {
            return UINavigationController(rootViewController: PromoViewController())
        }
    }

    // MARK: - Legacy

    private func loadInitialThemes() {
        let styleURLs = LegacyManager.shared.attributesURL()
        LegacyManager.shared.configure(with: styleURLs.compactMap { try? String(contentsOf: $0) })
    }

    private func currentThemeDidChange() {
        LegacyManager.shared.set(theme: LegacyCurrentThemeDefault.shared.current)
    }
}
