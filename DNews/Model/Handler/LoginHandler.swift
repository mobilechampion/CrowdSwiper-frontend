//
//  LoginHandler.swift
//  DNews
//
//  Created by robert pham on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoginHandler {
    
    func validate(email: String?, password: String?) -> (Bool, String?) {
        if email?.isEmpty == true {
            return (false, "Please enter email")
        }
        if email?.isEmail() == false {
            return (false, "Please enter a valid email")
        }
        if password?.isEmpty == true {
            return (false, "Please enter password")
        }
        return (true, nil)
    }
    
    func login(email: String, password: String, completion: CompletionHandlerBlock)  {
        let router = APIRouter.Login(email: email, password: password)
        APIManager.sharedInstance.requestAuthenRouter(router) { (json, error) in
            if let _ = json {
                UserManager.sharedInstance.userId = json!["data"]["id"].intValue
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }

    }
    
    func loginFacebook(token: String, completion: CompletionHandlerBlock) {
        let router = APIRouter.LoginFacebook(token: token)
        APIManager.sharedInstance.requestAuthenRouter(router) { (json, error) in
            if let _ = json {
                UserManager.sharedInstance.userId = json!["data"]["user"]["id"].intValue
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
    func loginGoogle(token: String, completion: CompletionHandlerBlock) {
        let router = APIRouter.LoginGoogle(token: token)
        APIManager.sharedInstance.requestAuthenRouter(router) { (json, error) in
            if let _ = json {
                UserManager.sharedInstance.userId = json!["data"]["user"]["id"].intValue
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
}