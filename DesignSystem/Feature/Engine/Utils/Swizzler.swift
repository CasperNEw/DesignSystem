//
//  Swizzler.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

// swiftlint:disable line_length

import UIKit

final internal class Swizzler {
    /// Настройка подмены методов
    ///
    /// Производим подмену `willMove` для вызова методов протокола `ThemeSubscriber` и применения всех стилей на элемент.
    /// Производим подмену `traitCollectionDidChange` для вызова методов протокола `ThemeSubscriber` в рантайме.
    class func configure() {
        struct Static {
            static let token = NSUUID().uuidString
        }

        Dispatch.once(token: Static.token) {
            method_exchangeImplementations(
                class_getInstanceMethod(UIView.self, #selector(UIView.willMove(toSuperview:)))!,
                class_getInstanceMethod(UIView.self, #selector(UIView._willMove(toSuperview:)))!
            )

            method_exchangeImplementations(
                class_getInstanceMethod(UIView.self, #selector(UIView.traitCollectionDidChange(_:)))!,
                class_getInstanceMethod(UIView.self, #selector(UIView._traitCollectionDidChange(_:)))!
            )

            method_exchangeImplementations(
                class_getInstanceMethod(UIImageView.self, #selector(UIImageView.traitCollectionDidChange(_:)))!,
                class_getInstanceMethod(UIImageView.self, #selector(UIImageView._traitCollectionDidChange(_:)))!
            )
        }
    }
}

fileprivate extension UIView {
    @objc func _willMove(toSuperview superview: UIView?) {
        _willMove(toSuperview: superview)
        guard let view = self as? ThemeObserver else { return }
        view._updateAppearance()

        if #available(iOS 13.0, *) { return }
        // Для iOS 12 производим подписку на уведомления о смене темы, в качестве ключа используем адрес объекта в памяти
        Dispatch.once(token: String(describing: Unmanaged.passUnretained(self).toOpaque())) {
            view.observe(event: .didChangeTheme)
        }
    }

    /// Перенаправляем на вызов метода протокола `ThemeSubscriber`
    @objc func _traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        _traitCollectionDidChange(previousTraitCollection)
        guard let view = self as? (ThemeSubscriber & UITraitEnvironment) else { return }
        view._traitCollectionDidChange(previousTraitCollection)
    }

    /// Перенаправляем на вызов метода протокола `ThemeSubscriber`
    @objc private func _updateAppearance() {
        guard let view = self as? ThemeSubscriber else { return }
        view._updateAppearance()
    }
}

fileprivate extension UIImageView {
    /// Перенаправляем на вызов метода протокола `ThemeSubscriber`
    @objc override func _traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        _traitCollectionDidChange(previousTraitCollection)
        guard let view = self as? (ThemeSubscriber & UITraitEnvironment) else { return }
        view._traitCollectionDidChange(previousTraitCollection)
    }
}
