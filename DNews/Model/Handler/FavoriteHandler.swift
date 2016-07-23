//
//  FavoriteHandler.swift
//  DNews
//
//  Created by quangpc on 7/4/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

class FavoriteHandler {
    
    var models = [ArticleModel]()
    var page = kStartPage
    var canLoadmore = false
    
    func checkRemovedModels() {
        for i in 0..<models.count {
            let model = models[i]
            if model.favorited == false {
                models.removeAtIndex(i)
                break
            }
        }
    }
    
    func getFavorites(completion: CompletionHandlerBlock)  {
        let router = APIRouter.FavoriteArticles(page: self.page)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                let array = json!["data"]["articles"].arrayValue
                let per_page = json!["per_page"].intValue
                self.canLoadmore = (per_page == array.count)
                self.page += 1
                for subJson in array {
                    let model = ArticleModel(json: subJson)
                    self.models.append(model)
                }
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
    func refreshData(completion: CompletionHandlerBlock) {
        let router = APIRouter.FavoriteArticles(page: kStartPage)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                let array = json!["data"]["articles"].arrayValue
                let per_page = json!["per_page"].intValue
                self.canLoadmore = (per_page == array.count)
                self.models.removeAll()
                self.page = kStartPage + 1
                for subJson in array {
                    let model = ArticleModel(json: subJson)
                    self.models.append(model)
                }
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
}