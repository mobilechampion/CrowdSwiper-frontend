//
//  QueueHandler.swift
//  DNews
//
//  Created by robert pham on 6/25/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

let kStartPage = 1

class QueueHandler {
    
    var models = [ArticleModel]()
    var page = kStartPage
    var canLoadmore = false
    
    func getQueue(completion: CompletionHandlerBlock) {
        let router = APIRouter.GetQueue(page: self.page)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                let array = json!["data"]["articles"].arrayValue
                let per_page = json!["per_page"].intValue
                self.canLoadmore = (per_page == array.count)
                self.page += 1
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
    
    func refreshData(completion: CompletionHandlerBlock) {
        let router = APIRouter.GetQueue(page: kStartPage)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                let array = json!["data"]["articles"].arrayValue
                self.models.removeAll()
                self.page = kStartPage + 1
                let per_page = json!["per_page"].intValue
                self.canLoadmore = (per_page == array.count)
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