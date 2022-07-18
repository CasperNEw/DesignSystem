//
//  LegacyPromoViewController.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

final class LegacyPromoViewController: LegacyViewController {

    // MARK: - Properties

    private let imageView = LegacyImageView()

    private lazy var toggleThemeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: Assets.Icons.paintbrush,
            style: .plain,
            target: self,
            action: #selector(toggleTheme)
        )
        button.tintColor = LegacyManager.shared.currentTheme?.attribute(named: "barButtonItem")?.tintColor
        return button
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureImageView()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(needToUpdateThemeNotification),
            name: .needToUpdateThemeNotification,
            object: nil
        )
    }

    // MARK: - Configure

    private func configureNavigationBar() {
        title = ThemeHelper.currentTheme.title
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItems = [toggleThemeButton]
    }

    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        imageView.lightImage = Assets.Illustration.beerLight
        imageView.darkImage = Assets.Illustration.beerDark

        let side = UIScreen.main.bounds.width * 2 / 3
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: side),
            imageView.widthAnchor.constraint(equalToConstant: side),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - needToUpdateThemeNotification

    @objc private func needToUpdateThemeNotification() {
        toggleThemeButton.tintColor = LegacyManager.shared.currentTheme?.attribute(named: "barButtonItem")?.tintColor
    }

    // MARK: - toggleTheme

    @objc private func toggleTheme() {
        let nextTheme = ThemeHelper.currentTheme.nextTheme

        switch nextTheme {
        case .light:
            LegacyManager.shared.isDeviceBasedTheme = false
            LegacyManager.shared.set(theme: .light)
        case .dark:
            LegacyManager.shared.isDeviceBasedTheme = false
            LegacyManager.shared.set(theme: .dark)
        case .system:
            LegacyManager.shared.isDeviceBasedTheme = true
        }

        title = nextTheme.title
        LegacyCurrentThemeDefault.shared.current = nextTheme.key
    }

    // MARK: - ThemeHelper

    private enum ThemeHelper {
        case light
        case dark

        @available(iOS 13.0, *)
        case system

        static var currentTheme: ThemeHelper {
            ThemeHelper(
                isDeviceBased: LegacyManager.shared.isDeviceBasedTheme,
                currentIsDark: LegacyManager.shared.currentTheme?.isDark
            )
        }

        var title: String {
            switch self {
            case .light:
                return "Light Theme"
            case .dark:
                return "Dark Theme"
            case .system:
                return "System Theme"
            }
        }

        var nextTheme: ThemeHelper {
            switch self {
            case .light:
                return .dark
            case .dark:
                return .system
            case .system:
                return .light
            }
        }

        var key: LegacyThemeKey {
            switch self {
            case .light:
                return .light
            case .dark:
                return .dark
            case .system:
                return LegacyManager.shared.currentDeviceTheme
            }
        }

        init(isDeviceBased: Bool, currentIsDark: Bool?) {
            if isDeviceBased {
                self = .system
                return
            }
            self = (currentIsDark ?? false) ? .dark : .light
        }
    }
}
