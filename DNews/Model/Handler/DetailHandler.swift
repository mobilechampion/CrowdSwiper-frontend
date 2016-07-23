//
//  DetailHandler.swift
//  DNews
//
//  Created by robert pham on 6/25/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

class DetailHandler {
    
    func vote(id: Int, value: Float, completion: (value: Float, error: AppError?)-> Void) {
        let router = APIRouter.Vote(id: id, value: value)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                var vl: Float = 0.5
                if let ave = json!["data"]["averaged_votes"].float {
                    vl = ave
                }
                completion(value: vl, error: nil)
            } else {
                completion(value: 0, error: error)
            }
        }
    }
    
}