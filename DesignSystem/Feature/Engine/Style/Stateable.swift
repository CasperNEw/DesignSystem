//
//  Stateable.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

// swiftlint:disable line_length

import UIKit

/// Протокол элемента умеющего находиться в различных состояниях
///
/// Аналогичен поведению `UIControl.State`, при реализации протокола необходимо вызывать метод `_updateAppearance` в didSet используемых свойст
public protocol Stateable: AnyObject {
    var isEnabled: Bool { get set }
    var isSelected: Bool { get set }
    var isHighlighted: Bool { get set }
    var state: UIControl.State { get }
}

extension Stateable {
    public var state: UIControl.State {
        var state = UIControl.State.normal

        if isEnabled == false {
            state.insert(.disabled)
        }

        if isSelected == true {
            state.insert(.selected)
        }

        if isHighlighted == true {
            state.insert(.highlighted)
        }

        return state
    }
}
