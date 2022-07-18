//
//  Style.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

// swiftlint:disable line_length

import UIKit

/// Подмена для использования в местах конфликта типа Style
public typealias DSStyle = Style

/// Абстракция Стиля
///
/// Набор замыканий, которые будут вызваны в определенные моменты изменения пользовательского интерфейса
public final class Style<T: Styleable> {
    /// Замыкание вызывающееся при назначении superview или при применении стиля, если superview уже назначено
    ///
    /// Дополнительно вызывается при каждой смене темы в iOS 12
    let appearance: (T) -> Void

    /// Замыкание вызывающееся при изменении стиля связанного с пользовательским интерфейсом
    ///
    /// Например, при смене светлого / темного стиля при выбранной системной теме
    let layer: (T) -> Void

    /// Замыкание вызывающееся при смене размера контента, UIContentSizeCategory
    let typography: (T, UITraitCollection?) -> Void

    /// Состояния для которых необходимо вызывать замыкания для изменения элемента
    var states: [UIControl.State] = []

    /// Инициализатор
    /// - Parameters:
    ///   - appearance: Замыкание вызывающееся при назначении superview или при применении стиля, если superview уже назначено
    ///   - layer: Замыкание вызывающееся при изменении стиля связанного с пользовательским интерфейсом
    ///   - typography: Замыкание вызывающееся при смене размера контента, UIContentSizeCategory
    public init(
        appearance: @escaping (_ view: T) -> Void = { _ in },
        layer: @escaping (_ view: T) -> Void = { _ in },
        typography: @escaping (_ view: T, _ previousTraitCollection: UITraitCollection?) -> Void = { _, _ in }
    ) {
        self.appearance = appearance
        self.layer = layer
        self.typography = typography
    }

    /// Применение стиля к элементу
    func apply(to view: T) -> Self {
        view.styles.append(self)
        if willMoved(view) {
            // Так как применение стилей происходит в момент назначения `superview`,
            // то необходимо дополнительно произвести применение стилей
            view._updateAppearance()
        }
        return self
    }

    /// Проверка на наличие `superview`
    private func willMoved(_ view: T) -> Bool {
        (view as? UIView)?.superview != nil
    }

    /// Установка набора состояний для которых необходимо применять данный стиль
    @discardableResult
    public func `for`(_ states: UIControl.State...) -> Self {
        self.states = states
        return self
    }
}

public extension Style {
    /// Марки для разового применения стилей
    enum Mark: String {
        case `default`
        case backgroundToken
        case tintToken
        case imageToken
    }
}
