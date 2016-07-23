//
//  TutorialCell.swift
//  DNews
//
//  Created by robert pham on 7/6/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class TutorialCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
