//
//  UIDevice+.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/08/2022.
//

import UIKit

public extension UIDevice {
    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }

    static var isIPhone5: Bool {
        isPhone && UIScreen.main.bounds.size.height == 568
    }
}
