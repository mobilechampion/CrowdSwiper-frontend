//
//  CreateLinkViewController.swift
//  DNews
//
//  Created by quangpc on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import WESlider

let didSubmitLinkSuccessfullyNotification = "com.dnews.didSubmitLinkNotification"

class CreateLinkViewController: BaseViewController, HomeStoryboardInstance {

    @IBOutlet weak var titleTf: BaseTextField!
    @IBOutlet weak var linkTf: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var slider: WESlider!
    
    let handler = SubmitLinkHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Submit Link"
        submitButton.backgroundColor = AppColor.buttonColor
        linkTf.layer.cornerRadius = 4
        linkTf.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        linkTf.layer.borderWidth = 1
        titleTf.placeholder = "Enter Title"
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.minimumTrackTintColor = UIColor.flatGrayColor()
        slider.maximumTrackTintColor = UIColor.flatWatermelonColor()
        slider.setThumbImage(UIImage(named: "icon-slider-small"), forState: .Normal)
        let red = UIColor.flatWhiteColor()
        let chunk = WEChunk(duration: 0.5, chunkColor: red)
        slider.setChunks([chunk])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let (success, msg) = handler.validate(titleTf.text, url: linkTf.text)
        if success {
            showLoadingOnView(self.view)
            handler.submitLink(titleTf.text!, url: linkTf.text, vote: slider.value, completion: { [weak self] (success, error) in
                removeAllLoadingOnView(self?.view)
                if success {
                    if let model = self?.handler.submitedModel {
                        NSNotificationCenter.defaultCenter().postNotificationName(didSubmitLinkSuccessfullyNotification, object: model)
                    }
                    UIAlertView(title: nil, message: "Submitted link successfully.", delegate: self, cancelButtonTitle: "OK").show()
                } else {
                    showErrorNotification(text: error?.failureReason)
                }
            })
        } else {
            showErrorNotification(text: msg)
        }
    }
    
    

}

extension CreateLinkViewController {
    override func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
