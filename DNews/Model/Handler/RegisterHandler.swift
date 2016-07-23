//
//  RegisterHandler.swift
//  DNews
//
//  Created by robert pham on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import Navajo

enum PoliticalPersuasion: Int {
    case democrat = 0
    case independent = 1
    case libertarian = 2
    case republican = 3
    case other = 4
    
    static func arrays()-> [PoliticalPersuasion] {
        return [PoliticalPersuasion.democrat, PoliticalPersuasion.independent, PoliticalPersuasion.libertarian, PoliticalPersuasion.republican, PoliticalPersuasion.other]
    }
    
    func displayString()-> String {
        switch self {
        case .democrat:
            return "Democrat"
        case .independent:
            return "Independent"
        case .libertarian:
            return "Libertarian"
        case .republican:
            return "Republican"
        case .other:
            return "None of the above"
        }
    }
}

class RegisterHandler {
    
    var political: PoliticalPersuasion?
    var birthday: NSDate?
    lazy var format: NSDateFormatter = {
        let fm = NSDateFormatter()
        fm.dateFormat = "MM-dd-yyyy"
        return fm
    }()
    
    func validate(email: String?, password: String?, confirm: String?) -> (Bool, String?) {
        if email?.isEmpty == true {
            return (false, "Please enter email")
        }
        if email?.isEmail() == false {
            return (false, "Please enter a valid email")
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
        
        if political == nil {
            return (false, "Please choose political persuasion")
        }
        return (true, nil)
    }
    
    func register(email: String, password: String, completion: CompletionHandlerBlock) {
        var birthString: String?
        if let birthday = birthday {
            birthString = self.format.stringFromDate(birthday)
        }
        let router = APIRouter.Signup(email: email, password: password, birthday: birthString, political: self.political!)
        APIManager.sharedInstance.requestAuthenRouter(router) { (json, error) in
            if let _ = json {
                UserManager.sharedInstance.userId = json!["data"]["id"].intValue
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
        
    }
    
}