//
//  LegacyView.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 14/07/2022.
//

import UIKit

open class LegacyView: UIView, LegacyElement {
    @objc dynamic public var theme: LegacyTheme? {
        didSet {
            subscribeForUpdates()
            refreshUI()
        }
    }

    public var attributeName: String?

    open func refreshUI() {
        if let backgroundColor = attribute?.backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        refreshUI()
    }
}
