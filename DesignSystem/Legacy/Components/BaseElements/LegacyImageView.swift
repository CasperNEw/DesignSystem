//
//  LegacyImageView.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

open class LegacyImageView: UIImageView, LegacyElement {
    @objc dynamic public var theme: LegacyTheme? {
        didSet {
            subscribeForUpdates()
            refreshUI()
        }
    }

    public var attributeName: String?

    public var darkImage: UIImage? {
        didSet { updateImage() }
    }

    public var lightImage: UIImage? {
        didSet { updateImage() }
    }

    override open var image: UIImage? {
        get {
            return _image
        }
        set {
            lightImage = newValue
        }
    }

    private var _image: UIImage? {
        didSet {
            super.image = _image
        }
    }

    open func refreshUI() {
        backgroundColor = attribute?.backgroundColor
        if let tintColor = attribute?.tintColor {
            self.tintColor = tintColor
        }
        updateImage()
    }

    private func updateImage() {
        let isDark = theme?.isDark ?? false
        if isDark {
            let image = darkImage ?? lightImage
            self._image = image
        } else {
            self._image = lightImage
        }
    }
}
