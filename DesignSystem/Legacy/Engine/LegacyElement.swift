//
//  LegacyElement.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 12/07/2022.
//

import UIKit

public protocol LegacyElement: UIView {
    var theme: LegacyTheme? { get set }
    var attributeName: String? { get set }
    func refreshUI()
}

public extension LegacyElement {
    func apply(attribute: String) {
        attributeName = attribute
        refreshUI()
    }

    var attribute: LegacyAttribute? {
        guard let name = attributeName else { return nil }
        return theme?.attribute(named: name)
    }
}

@objcMembers
public class ObjcAction {
    private let action: (LegacyTheme) -> Void

    public init(action: @escaping (LegacyTheme) -> Void) {
        self.action = action
    }

    public func perform(_ notification: Notification) {
        if let theme = notification.userInfo?["theme"] as? LegacyTheme {
            action(theme)
        }
    }
}

private struct AssotiatedKeys {
    static var actionKey: UInt8 = 0
}

public extension LegacyElement {
    var action: ObjcAction? {
        get {
            guard
                let value = objc_getAssociatedObject(self, &AssotiatedKeys.actionKey) as? ObjcAction
            else { return nil }
            return value
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssotiatedKeys.actionKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    func subscribeForUpdates() {
        guard action == nil else { return }

        let action = ObjcAction { [weak self] theme in
            self?.theme = theme
            self?.refreshUI()
        }

        NotificationCenter.default.addObserver(
            action,
            selector: #selector(ObjcAction.perform),
            name: .needToUpdateThemeNotification,
            object: nil
        )
        self.action = action
    }
}
