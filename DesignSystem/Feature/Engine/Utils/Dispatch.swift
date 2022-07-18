//
//  Dispatch.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import Foundation

final class Dispatch {
    private static var tokens = [String]()

    /// Разовое выполнение блока
    ///
    /// - Parameters:
    ///   - token: Уникальный токен
    ///   - closure: Блок для разового выполнения
    /// - Returns: Флаг успешности выполнения операции
    @discardableResult
    class func once(token: String, closure: () -> Void) -> Bool {
        objc_sync_enter(self)

        defer {
            objc_sync_exit(self)
        }

        guard !tokens.contains(token) else { return false }

        tokens.append(token)
        closure()
        return true
    }
}
