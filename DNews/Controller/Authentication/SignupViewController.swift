//
//  SignupViewController.swift
//  DNews
//
//  Created by robert pham on 6/19/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import IQActionSheetPickerView
import Hokusai

class SignupViewController: BaseViewController, AuthenticationStoryboardInstance {

    @IBOutlet weak var emailTf: BaseTextField!
    @IBOutlet weak var passwordTf: BaseTextField!
    @IBOutlet weak var confirmPassTf: BaseTextField!
    @IBOutlet weak var signupButton: BaseButton!
    @IBOutlet weak var politicalPicker: DropdownControl!
    
    @IBOutlet weak var birthdayPicker: DropdownControl!
    let handler = RegisterHandler()
    
    lazy var format: NSDateFormatter = {
        let fm = NSDateFormatter()
        fm.dateFormat = "yyyy/MM/dd"
        return fm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "DNews"
        signupButton.backgroundColor = AppColor.buttonColor
        let skipButton = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: #selector(SignupViewController.skip))
        self.navigationItem.rightBarButtonItem = skipButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func skip() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let (success, msg) = handler.validate(emailTf.text, password: passwordTf.text, confirm: confirmPassTf.text)
        if success {
            showLoadingOnView(self.view)
            handler.register(emailTf.text!, password: passwordTf.text!, completion: { [weak self] (success, error) in
                removeAllLoadingOnView(self?.view)
                if success {
                    self?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    showErrorNotification(text: error?.failureReason)
                }
            })
        } else {
            showSimpleAlert(title: "Error", message: msg)
        }
    }
    
    func reloadPolitical() {
        if let _ = handler.political {
            politicalPicker.contentTf.text = handler.political?.displayString()
        } else {
            politicalPicker.contentTf.text = ""
        }
    }
    
    @IBAction func politicalPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let hokusai = Hokusai()
        for type in PoliticalPersuasion.arrays() {
            hokusai.addButton(type.displayString(), action: { 
                self.handler.political = type
                self.reloadPolitical()
            })
        }
        hokusai.show()
    }
    
    @IBAction func birthdayPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let picker = IQActionSheetPickerView(title: "Select birthday", delegate: self)
        picker.actionSheetPickerStyle = .DatePicker
        picker.show()
    }

}
extension SignupViewController: IQActionSheetPickerViewDelegate {
    func actionSheetPickerView(pickerView: IQActionSheetPickerView!, didSelectDate date: NSDate!) {
        self.handler.birthday = date
        birthdayPicker.contentTf.text = self.format.stringFromDate(date)
    }
}

