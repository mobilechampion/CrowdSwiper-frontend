//
//  SubmittedCell.swift
//  DNews
//
//  Created by quangpc on 7/4/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class SubmittedCell: FeedCell {

    @IBOutlet weak var approveButton: UIButton!
    var approveButtonBlock:()-> Void = {arg in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindData() {
        super.bindData()
        if let model = model {
            approveButton.selected = model.approved
        }
    }
    
    @IBAction func submittedButtonPressed(sender: AnyObject) {
        self.approveButtonBlock()
    }
    
}
