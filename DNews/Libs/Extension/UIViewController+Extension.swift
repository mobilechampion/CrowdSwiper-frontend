//
//  UIViewController+Extension.swift
//  DNews
//
//  Created by robert pham on 6/21/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func removeAllChildControllers() {
        for child in self.childViewControllers {
            child.willMoveToParentViewController(nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
}