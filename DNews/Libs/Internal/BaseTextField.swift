//
//  BaseTextField.swift
//  LGBT
//
//  Created by quangpc on 4/22/16.
//  Copyright © 2016 Freelancer. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {

    @IBInspectable var padding: CGFloat = 0 {
        didSet {
            
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
            self.layer.borderWidth = 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.CGColor
        self.layer.borderWidth = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(padding, 0, bounds.size.width - 2 * padding, bounds.size.height)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(padding, 0, bounds.size.width - 2 * padding, bounds.size.height)
    }
    
}
