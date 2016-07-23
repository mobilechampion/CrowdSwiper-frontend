//
//  UserManager.swift
//  DNews
//
//  Created by robert pham on 6/19/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

class UserManager {
    
    struct Constants {
        static let userTokenKey = "com.dnews.user.token"
        static let userIdKey = "com.dnews.user.id"
    }
    
    static let sharedInstance: UserManager = {
        return UserManager()
    }()
    
    var userToken: UserToken? {
        didSet {
            APIManager.sharedInstance.loadToken()
        }
    }
    var userId: Int = 0 {
        didSet {
            NSUserDefaults.standardUserDefaults().setInteger(userId, forKey: Constants.userIdKey)
        }
    }
    
    init() {
        self.userToken = UserToken.loadUserToken()
        self.userId = NSUserDefaults.standardUserDefaults().integerForKey(Constants.userIdKey)
    }
    
    func isLoggedIn()-> Bool {
        if userToken != nil {
            return true
        }
        return false
    }
    
    func logout() {
        self.userToken = nil
        UserToken.reset()
        self.userId = 0
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Constants.userIdKey)
    }
    
}
private let saveKey = "co.dnews.usertoken.storeKey"
class UserToken {
    
    var accessToken: String = ""
    var client: String?
    var expiry = 0
    var uid: String?
    
    init(token: String) {
        self.accessToken = token
        
    }
    
    class func loadUserToken()-> UserToken? {
        if let header = NSUserDefaults.standardUserDefaults().objectForKey(saveKey) as? [NSObject : AnyObject] {
            guard let token = header["access-token"] as? String else {
                return nil
            }
            let model = UserToken(token: token)
            model.client = header["client"] as? String
            if let expiry = header["expiry"] as? Int {
                model.expiry = expiry
            }
            model.uid = header["uid"] as? String
            
            return model
        }
        return nil
    }
    
    class func reset() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(saveKey)
    }
    
    class func saveWithHeaders(header: [NSObject : AnyObject]?) {
        if let header = header {
            guard let token = header["access-token"] as? String else {
                return
            }
            let model = UserToken(token: token)
            model.client = header["client"] as? String
            if let expiry = header["expiry"] as? Int {
                model.expiry = expiry
            }
            model.uid = header["uid"] as? String
            
            UserManager.sharedInstance.userToken = model
            NSUserDefaults.standardUserDefaults().setObject(header, forKey: saveKey)
            
        }
    }
}