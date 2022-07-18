//
//  PromoViewController.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

final class PromoViewController: ViewController {
    // MARK: - Properties

    private let imageView = ImageView(imageToken: .ilBeer)

    private lazy var toggleThemeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: Assets.Icons.paintbrush,
            style: .plain,
            target: self,
            action: #selector(toggleTheme)
        )
        button.tintColor = ColorToken.barButtonItem.color
        return button
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        layoutImageView()
    }

    // MARK: - Configure

    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItems = [toggleThemeButton]
        configureTitle(with: ThemeProvider.shared.currentTheme.rawValue)
    }

    private func layoutImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        let side = UIScreen.main.bounds.width * 2 / 3
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: side),
            imageView.widthAnchor.constraint(equalToConstant: side),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - toggleTheme

    @objc private func toggleTheme() {
        if #available(iOS 13.0, *) {
            let currentTheme = ThemeProvider.shared.currentTheme
            var newStyle: UIUserInterfaceStyle = .unspecified
            switch currentTheme {
            case .light:
                newStyle = .dark
            case .dark:
                newStyle = .unspecified
            case .system:
                newStyle = .light
            }
            ThemeProvider.shared.applyTheme(Theme(style: newStyle))
            configureTitle(with: newStyle.rawValue)
        } else {
            let newTheme: Theme = ThemeProvider.shared.currentTheme == .light ? .dark : .light
            ThemeProvider.shared.applyTheme(newTheme)
            configureTitle(with: newTheme.rawValue)
        }
    }

    private func configureTitle(with themeStyle: Int) {
        switch themeStyle {
        case 0:
            title = "System Theme"
        case 1:
            title = "Light Theme"
        case 2:
            title = "Dark Theme"
        default:
            title = "Error"
        }
    }
}
