//
//  ProgressBarView.swift
//  DNews
//
//  Created by robert pham on 6/23/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {

    lazy var leftView = UIView()
    lazy var rightView = UIView()
    
    var progress: CGFloat = 0.5 {
        didSet {
            self.setNeedsLayout()
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
        self.addSubview(leftView)
        self.addSubview(rightView)
        leftView.backgroundColor = UIColor.flatGrayColor()
        rightView.backgroundColor = UIColor.flatSkyBlueColor()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var pro = progress
        if pro > 1 {
            pro = 1
        }
        if pro < 0 {
            pro = 0
        }
        let width = bounds.size.width * pro
        leftView.frame = CGRectMake(0, 0, width, bounds.size.height)
        rightView.frame = CGRectMake(CGRectGetMaxX(leftView.frame), 0, bounds.size.width - CGRectGetMaxX(leftView.frame), bounds.size.height)
        
    }

}
