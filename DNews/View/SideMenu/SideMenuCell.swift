//
//  SideMenuCell.swift
//  DNews
//
//  Created by robert pham on 6/21/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.contentLabel.textColor = UIColor.whiteColor()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.backgroundColor = selected ? UIColor.whiteColor().colorWithAlphaComponent(0.3) : UIColor.clearColor()
    }
    
}
