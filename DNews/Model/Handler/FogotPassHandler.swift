//
//  FogotPassHandler.swift
//  DNews
//
//  Created by robert pham on 7/7/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import Navajo

class ForgotPassHandler {
    
    func verifyFirstStep(email: String?) -> (success: Bool, message: String?) {
        if email?.isEmpty == true {
            return (false, "Please enter your email")
        }
        if email?.isEmail() == false {
            return (false, "Please enter a valid email address")
        }
        return (true, nil)
    }
    
    func verifySecondStep(token: String?, password: String?, confirm: String?) -> (Bool, String?) {
        if token?.isEmpty == true {
            return (false, "Please enter token")
        }
        if password?.isEmpty == true {
            return (false, "Please enter password")
        }
        if confirm != password {
            return (false, "Password not match")
        }
        let rule1 = NJORequiredCharacterRule.uppercaseCharacterRequiredRule()
        let rule2 = NJORequiredCharacterRule.decimalDigitCharacterRequiredRule()
        
        let validator = NJOPasswordValidator(rules: [rule1, rule2])
        let result = validator.validatePassword(password!, failingRules: nil)
        if result == false {
            return (false, "Please make sure your password contains:\n- Upercase letter\n- Number")
        }
        
        return (true, nil)
    }
    
    func sendToken(email: String, completion: CompletionHandlerBlock) {
        let router = APIRouter.ForgotPass(email: email)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
    func resetPass(pass: String, token: String, completion: CompletionHandlerBlock) {
        let router = APIRouter.ResetPass(token: token, password: pass)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
}