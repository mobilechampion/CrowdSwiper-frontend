//
//  Utils.swift
//  LGBT
//
//  Created by quangpc on 4/11/16.
//  Copyright © 2016 Freelancer. All rights reserved.
//

import Foundation
import MBProgressHUD
import TWMessageBarManager

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

// MARK: Loading
func showLoadingOnView(view: UIView?) {
    if let _ = view {
        MBProgressHUD.showHUDAddedTo(view!, animated: true)
    }
}

func removeAllLoadingOnView(view: UIView?) {
    if let _ = view {
        MBProgressHUD.hideAllHUDsForView(view!, animated: true)
    }
}

func showSimpleAlert(title title: String?, message: String?) {
    UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
}

func viewWithClassname(className: String) -> UIView {
    let views = NSBundle.mainBundle().loadNibNamed(className, owner: nil, options: nil)
    if views.count > 0 {
        return views.first as! UIView
    }
    return UIView()
}

func showInfoNotification(title title: String?) {
    if let _ = title {
        TWMessageBarManager.sharedInstance().showMessageWithTitle(nil, description: title, type: TWMessageBarMessageType.Info)
    }
}
func showSuccessNotification(text text: String?) {
    if let _ = text {
        TWMessageBarManager.sharedInstance().showMessageWithTitle(nil, description: text, type: .Success)
    }
}
func showErrorNotification(text text: String?) {
    if let _ = text {
        TWMessageBarManager.sharedInstance().showMessageWithTitle(nil, description: text, type: .Error)
    }
}

