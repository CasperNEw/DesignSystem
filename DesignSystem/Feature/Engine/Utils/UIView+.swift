//
//  UIView+.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

// swiftlint:disable line_length

import UIKit

public extension UIView {
    /// Реализация `dispatch_once`
    ///
    /// Блок кода вызывается единожды за жизненный цикл приложения, в качетсве ключа используется адрес объекта в памяти с добавлением `mark`.
    @discardableResult
    func once(mark: String, closure: () -> Void) -> Bool {
        Dispatch.once(
            token: String(describing: Unmanaged.passUnretained(self).toOpaque()).appending("_\(mark)"),
            closure: closure
        )
    }
}
