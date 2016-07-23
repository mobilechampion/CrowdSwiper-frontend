//
//  DropdownControl.swift
//  LGBT
//
//  Created by robert pham on 4/22/16.
//  Copyright © 2016 Freelancer. All rights reserved.
//

import UIKit

class DropdownControl: UIControl {

    @IBInspectable var radius: CGFloat = 4 {
        didSet {
            self.layer.cornerRadius = radius
        }
    }
    
    let contentTf = UITextField()
    let dropIcon = UIImageView()
    
    @IBInspectable var placeHolder: String? {
        didSet {
            contentTf.placeholder = placeHolder
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
    
    func setup() {
        contentTf.enabled = false
        contentTf.placeholder = placeHolder
        contentTf.textColor = UIColor.blackColor()
        self.layer.cornerRadius = radius
        self.backgroundColor = UIColor.whiteColor()
        contentTf.font = UIFont.systemFontOfSize(14)
        dropIcon.image = UIImage(named: "icon-dropdown-small")
        self.addSubview(contentTf)
        self.addSubview(dropIcon)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(DropdownControl.didTap))
        self.userInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        
        self.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.layer.borderWidth = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dropIcon.frame = CGRectMake(bounds.size.width - 15, CGRectGetMidY(bounds) - 3, 9, 5)
        contentTf.frame = CGRectMake(10, 0, bounds.size.width - 25, bounds.size.height)
    }
    
    func didTap() {
        self.sendActionsForControlEvents(.TouchUpInside)
    }
    
    func setText(text: String?) {
        self.contentTf.text = text
    }
    
    func getText() -> String {
        return self.contentTf.text!
    }
}
