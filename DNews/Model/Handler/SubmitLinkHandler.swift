//
//  SubmitLinkHandler.swift
//  DNews
//
//  Created by robert pham on 6/22/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

class SubmitLinkHandler {
    
    var models = [ArticleModel]()
    var page = kStartPage
    var canLoadmore = false
    var submitedModel: ArticleModel?
    
    func submitLink(title: String, url: String, vote: Float, completion: CompletionHandlerBlock) {
        let router = APIRouter.SubmitArticle(title: title, url: url, vote: vote)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                let modelJson = json!["data"]["article"]
                self.submitedModel = ArticleModel(json: modelJson)
                self.submitedModel?.averaged_votes = vote
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
    func validate(title: String?, url: String?) -> (Bool, String?) {
        if title?.isEmpty == true {
            return (false, "Please enter Title")
        }
        if url?.isEmpty == true {
            return (false, "Please enter Link")
        }
        return (true, nil)
    }
    
    func getListSubmitted(uid: Int, completion: CompletionHandlerBlock) {
        let router = APIRouter.ListSubmited(userId: uid, page: self.page)
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
    
    func refreshData(uid: Int, completion: CompletionHandlerBlock) {
        let router = APIRouter.ListSubmited(userId: uid, page: kStartPage)
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