//
//  ProfileHandler.swift
//  DNews
//
//  Created by robert pham on 7/15/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

class ProfileHandler {
    
    var user: UserModel?
    
    func getProfile(completion: CompletionHandlerBlock) {
        let router = APIRouter.Profile(userId: UserManager.sharedInstance.userId)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let json = json {
                self.user = UserModel(json: json["data"]["user"])
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
}