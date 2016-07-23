//
//  BaseButton.swift
//  DNews
//
//  Created by quangpc on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = cornerRadius
    }

}
