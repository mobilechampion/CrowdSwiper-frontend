//
//  UIConstants.swift
//  DNews
//
//  Created by quangpc on 7/1/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import UIKit

struct UIConstants {
    static let screenWidth: CGFloat = {
        let bounds = UIScreen.mainScreen().bounds
        return min(bounds.size.width, bounds.size.height)
    }()
    
}

struct AppColor {
    static let mainColor = UIColor(hexString: "3d5171")
    static let buttonColor = UIColor(hexString: "5fa0b4")
}