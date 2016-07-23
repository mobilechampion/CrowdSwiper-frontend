//
//  HomeHandler.swift
//  DNews
//
//  Created by robert pham on 6/23/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

class HomeHandler {
    
    var models = [ArticleModel]()
    
    func getArticles(completion: CompletionHandlerBlock) {
        let router = APIRouter.GetListArticles()
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                let array = json!["data"]["articles"].arrayValue
                self.models.removeAll()
                for subJson in array {
                    let mod = ArticleModel(json: subJson)
                    self.models.append(mod)
                }
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
}