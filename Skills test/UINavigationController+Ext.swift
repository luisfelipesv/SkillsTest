//
//  UINavigationController+Ext.swift
//  Skills test
//
//  Created by Luis Salazar on 2/20/22.
//

import UIKit

// MARK: UINavigationController Extension
extension UINavigationController {
    // MARK: Override Variables
    open override var shouldAutorotate: Bool {
        return false
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
