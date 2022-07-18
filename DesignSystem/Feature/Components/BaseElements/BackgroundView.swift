//
//  BackgroundView.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

public final class BackgroundView: UIView, Styleable, Backgroundable {
    public var styles: [Style<BackgroundView>] = []

    public var backgroundToken: ColorToken? {
        didSet { applyOnce(mark: .backgroundToken, style: .background)}
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init(backgroundToken: ColorToken) {
        super.init(frame: .zero)
        self.backgroundToken = backgroundToken
        applyOnce(mark: .backgroundToken, style: .background)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
