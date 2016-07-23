//
//  ForgotPassViewController.swift
//  DNews
//
//  Created by robert pham on 7/7/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class ForgotPassViewController: BaseViewController, AuthenticationStoryboardInstance {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var emailTf: BaseTextField!
    @IBOutlet weak var sendButton: BaseButton!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var tokenTf: BaseTextField!
    @IBOutlet weak var passwordTf: BaseTextField!
    
    @IBOutlet weak var resetButton: BaseButton!
    @IBOutlet weak var confirmPassTf: BaseTextField!
    
    let handler = ForgotPassHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Forgot Password"
        sendButton.backgroundColor = AppColor.buttonColor
        resetButton.backgroundColor = AppColor.buttonColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendTokenButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let (success, msg) = handler.verifyFirstStep(emailTf.text)
        if success {
            showLoadingOnView(self.view)
            handler.sendToken(emailTf.text!, completion: { [weak self] (success, error) in
                dispatch_async(dispatch_get_main_queue(), { 
                    removeAllLoadingOnView(self?.view)
                    if success {
                        self?.firstView.hidden = true
                        self?.secondView.hidden = false
                        
                    } else {
                        showErrorNotification(text: error?.failureReason)
                    }
                })
            })
        } else {
            showErrorNotification(text: msg)
        }
    }

    @IBAction func resetPassPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let (success, msg) = handler.verifySecondStep(tokenTf.text, password: passwordTf.text, confirm: confirmPassTf.text)
        if success {
            showLoadingOnView(self.view)
            handler.resetPass(passwordTf.text!, token: tokenTf.text!, completion: { [weak self] (success, error) in
                dispatch_async(dispatch_get_main_queue(), {
                    removeAllLoadingOnView(self?.view)
                    if success {
                        UIAlertView(title: "", message: "Reset password successfully. You can login now", delegate: self, cancelButtonTitle: "OK").show()
                    } else {
                        showErrorNotification(text: error?.failureReason)
                    }
                })
            })
        } else {
            showErrorNotification(text: msg)
        }
    }
    

}

extension ForgotPassViewController {
    override func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
}
