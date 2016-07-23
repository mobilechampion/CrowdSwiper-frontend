//
//  FeedCell.swift
//  DNews
//
//  Created by robert pham on 6/23/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import WESlider
import MGSwipeTableCell

class FeedCell: MGSwipeTableCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slider: WESlider!
    
    var model: ArticleModel? {
        didSet {
            bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.minimumTrackTintColor = UIColor.flatSkyBlueColor()
        slider.maximumTrackTintColor = UIColor.flatWatermelonColor()
        slider.setThumbImage(UIImage(named: "icon-slider-small"), forState: .Normal)
        let red = UIColor.flatWhiteColor()
        let chunk = WEChunk(duration: 0.5, chunkColor: red)
        slider.setChunks([chunk])
        slider.userInteractionEnabled = false
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData() {
        if let model = model {
            titleLabel.attributedText = model.titleAttributed
            slider.value = model.averaged_votes
        }
    }
}


