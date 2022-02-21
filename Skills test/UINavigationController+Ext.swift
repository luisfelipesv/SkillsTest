//
//  UINavigationController+Ext.swift
//  Skills test
//
//  Created by Luis Salazar on 2/20/22.
//

import UIKit

// MARK: UINavigationController Extension
/// This UINavigationController extension purpose is to just enable portrait mode for the user.
extension UINavigationController {
    // MARK: Override Variables
    /// We return false so we don't let the user autorotate. We only want to enable portrait mode.
    open override var shouldAutorotate: Bool {
        return false
    }
    
    /// We only enable portrait mode
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
