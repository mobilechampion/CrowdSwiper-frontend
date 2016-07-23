//
//  NSObject+Extension.swift
//  DNews
//
//  Created by quangpc on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    class func className()-> String {
        return String(self.self)
    }
}