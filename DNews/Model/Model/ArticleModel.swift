//
//  ArticleModel.swift
//  DNews
//
//  Created by robert pham on 6/23/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import SwiftyJSON

class ArticleModel {
    
    static let dateFormat: NSDateFormatter = {
        let fm = NSDateFormatter()
        fm.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        return fm
    }()
    static let displayFormat: NSDateFormatter = {
        let fm = NSDateFormatter()
        fm.dateFormat = "yyyy/MM/dd HH:mm"
        return fm
    }()
    
    var id = 0
    var user_id = 0
    var title = ""
    var url = ""
    var total_view = 0
    var created_at = ""
    var updated_at = ""
    var averaged_votes: Float = 0.5
    
    var titleAttributed: NSMutableAttributedString?
    var voted = false
    var didCheckVote = false
    
    var favorited = false
    var approved = false
    var available = true
    var is_top = false
    var user: UserModel?
    var isCurrentUser = false
    
    init(json: JSON) {
        id = json["id"].intValue
        user_id = json["user_id"].intValue
        title = json["title"].stringValue
        url = json["url"].stringValue
        total_view = json["total_view"].intValue
        if let ave = json["averaged_votes"].float {
            averaged_votes = ave
        } else {
            averaged_votes = 0.5
        }
        favorited = json["favorited"].boolValue
        approved = json["approved"].boolValue
        self.user = UserModel(json: json["user"])
        is_top = json["is_top"].boolValue
        
        let createdString = json["created_at"].stringValue
        if let date = ArticleModel.dateFormat.dateFromString(createdString) {
            self.created_at = ArticleModel.displayFormat.stringFromDate(date)
            let oneDayLater = date.dateByAddingDays(1)
            if NSDate() < oneDayLater {
                available = false
            }
        }
        if user_id == UserManager.sharedInstance.userId {
            isCurrentUser = true
        }
        if available {
            if isCurrentUser && is_top && approved == false {
                self.titleAttributed = NSMutableAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.flatWatermelonColor(), NSFontAttributeName: UIFont.systemFontOfSize(13), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
            } else {
                self.titleAttributed = NSMutableAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.flatBlackColor(), NSFontAttributeName: UIFont.systemFontOfSize(13), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
            }
            
        } else {
            self.titleAttributed = NSMutableAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.flatGrayColor(), NSFontAttributeName: UIFont.systemFontOfSize(13), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
        }
        
    }
    
    func checkVote(completion: CompletionHandlerBlock) {
        if didCheckVote {
            completion(success: true, error: nil)
            return
        }
        let router = APIRouter.GetArticleInfor(id: id)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let json = json {
                self.voted = json["data"]["article"]["voted"].boolValue
                self.averaged_votes = json["data"]["article"]["averaged_votes"].floatValue
                self.didCheckVote = true
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
        
    }
    
    func like(completion: CompletionHandlerBlock) {
        let router = APIRouter.LikeArticle(id: self.id)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                self.favorited = true
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    func unLike(completion: CompletionHandlerBlock) {
        let router = APIRouter.UnLikeArticle(id: self.id)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                self.favorited = false
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
    func update(approve: Bool, completion: CompletionHandlerBlock) {
        let router = APIRouter.UpdateArticle(id: self.id, approved: approve)
        APIManager.sharedInstance.requestDataForRouter(router) { (json, error) in
            if let _ = json {
                self.approved = approve
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }
    
    func updateLabel() {
        self.titleAttributed = NSMutableAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.flatBlackColor(), NSFontAttributeName: UIFont.systemFontOfSize(13), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
    }
}
