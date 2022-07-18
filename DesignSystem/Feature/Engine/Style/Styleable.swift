//
//  Styleable.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

/// Протокол элемента умеющего взаимодействовать со стилями
public protocol Styleable: ThemeObserver {
    /// Хранилище стилей элемента
    var styles: [Style<Self>] { get set }

    /// Применить стиль на элемент
    @discardableResult
    func apply(style: Style<Self>) -> Style<Self>

    /// Применить стили на элемент
    @discardableResult
    func apply(styles: Style<Self>...) -> [Style<Self>]
}

public extension Styleable {
    @discardableResult
    func apply(style: Style<Self>) -> Style<Self> {
        return style.apply(to: self)
    }

    @discardableResult
    func apply(styles: Style<Self>...) -> [Style<Self>] {
        return styles.map { apply(style: $0) }
    }

    // MARK: - ThemeSubscriber

    func updateAppearance() {
        styles.filter(stateCondition).forEach({ $0.appearance(self) })
    }

    func updateUserInterfaceStyle() {
        styles.filter(stateCondition).forEach({ $0.layer(self) })
    }

    func updateTextStyle(_ previousTraitCollection: UITraitCollection?) {
        styles.filter(stateCondition).forEach({ $0.typography(self, previousTraitCollection) })
    }
}

public extension Styleable where Self: UIView {
    /// Разовое применение стиля по указанной марке
    /// - Parameters:
    ///   - string: уникальная строка для данного типа стилей
    ///   - style: стиль применяемый к элементу
    ///
    /// Аналог `dispatch_once`, для ключа используется адрес объекста в памяти + `_string`.
    /// Необходим для предотвращения добавления избыточных стилей в масcив styles.
    /// Если стиль уже применен, то принудительно вызываются все замыкания стиля.
    func applyOnce(string: String, style: Style<Self>) {
        let success = once(mark: string, closure: { apply(style: style) })
        if !success {
            style.appearance(self)
            style.layer(self)
            style.typography(self, traitCollection)
        }
    }

    /// Разовое применение стиля по указанной марке
    /// - Parameters:
    ///   - mark: уникальная марка для данного типа стилей
    ///   - style: стиль применяемый к элементу
    ///
    /// Аналог `dispatch_once`, для ключа используется адрес объекста в памяти + `_mark`.
    /// Необходим для предотвращения добавления избыточных стилей в масcив styles.
    /// Если стиль уже применен, то принудительно вызываются все замыкания стиля.
    func applyOnce(mark: Style<Self>.Mark, style: Style<Self>) {
        applyOnce(string: mark.rawValue, style: style)
    }
}

private extension Styleable {
    /// Вспомогательный метод для проверки допустимости текущего состояния для конкретного стиля элемента
    func stateCondition(_ style: Style<Self>) -> Bool {
        guard let object = self as? Stateable else { return true }
        return style.states.isEmpty ? true : style.states.contains(object.state)
    }
}
