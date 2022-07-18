//
//  LegacyViewController.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

open class LegacyViewController: UIViewController {
    open override func loadView() {
        let rootView = LegacyView()
        rootView.attributeName = "rootViewController"
        view = rootView
    }
}
