//
//  APIConstants.swift
//  DNews
//
//  Created by robert pham on 6/19/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    static let baseUrlString = "http://128.199.244.68:3456/"
    
    case Login(email: String, password: String)
    case Signup(email: String, password: String, birthday: String?, political: PoliticalPersuasion)
    case LoginFacebook(token: String)
    case LoginGoogle(token: String)
    case SubmitArticle(title: String, url: String, vote: Float)
    case GetArticleInfor(id: Int)
    case GetListArticles()
    case ListSubmited(userId: Int, page: Int)
    case Profile(userId: Int)
    case Vote(id: Int, value: Float)
    case GetQueue(page: Int)
    case LikeArticle(id: Int)
    case UnLikeArticle(id: Int)
    case FavoriteArticles(page: Int)
    case UpdateArticle(id: Int, approved: Bool)
    case ForgotPass(email: String)
    case ResetPass(token: String, password: String)

    var method: Alamofire.Method {
        switch self {
        case .Login(email: _, password: _):
            return .POST
        case .Signup(email: _, password: _, birthday: _, political: _):
            return .POST
        case .LoginFacebook(token: _):
            return .POST
        case .LoginGoogle(token: _):
            return .POST
        case .SubmitArticle(title: _, url: _, vote: _):
            return .POST
        case .Vote(id: _, value: _):
            return .POST
        case .LikeArticle(id: _):
            return .POST
        case .UnLikeArticle(id: _):
            return .POST
        case .UpdateArticle(id: _, approved: _):
            return .PUT
        case .ForgotPass(email: _):
            return .POST
        case .ResetPass(token: _, password: _):
            return .POST
        default:
            return .GET
        }
    }
    
    var urlString: String {
        switch self {
        case .Login(email: _, password: _):
            return requestUrl(path: "users/sign_in")
        case .Signup(email: _, password: _, birthday: _, political: _):
            return requestUrl(path: "users")
        case .LoginFacebook(token: _):
            return requestUrl(path: "users/oauth/facebook")
        case .SubmitArticle(title: _, url: _, vote: _):
            return requestUrl(path: "articles")
        case .GetArticleInfor(id: let id):
            return requestUrl(path: "articles/\(id)")
        case .GetListArticles():
            return requestUrl(path: "articles")
        case .ListSubmited(userId: let uid, page: _):
            return requestUrl(path: "users/\(uid)/submit_articles")
        case .LoginGoogle(token: _):
            return requestUrl(path: "users/oauth/google")
        case .Profile(userId: let uid):
            return requestUrl(path: "users/\(uid)/information")
        case .Vote(id: let id, value: _):
            return requestUrl(path: "articles/\(id)/vote")
        case .GetQueue(page: _):
            return requestUrl(path: "articles/queue")
        case .LikeArticle(id: let id):
            return requestUrl(path: "articles/\(id)/like")
        case .UnLikeArticle(id: let id):
            return requestUrl(path: "articles/\(id)/unlike")
        case .FavoriteArticles(page: _):
            return requestUrl(path: "articles/favorites")
        case .UpdateArticle(id: let id, approved: _):
            return requestUrl(path: "articles/\(id)")
        case .ForgotPass(email: _):
            return requestUrl(path: "users/forgot_password")
        case .ResetPass(token: _, password: _):
            return requestUrl(path: "users/reset_password")
        }
    }
    
    private func requestUrl(path path: String)-> String {
        return APIRouter.baseUrlString + path
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .Login(email: let email, password: let password):
            return ["email": email, "password": password]
        case .Signup(email: let email, password: let password, birthday: let birthday, political: let pol):
            var params: [String: AnyObject] = ["email": email, "password": password, "password_confirmation": password, "political_persuasion": pol.rawValue]
            if let birthday = birthday {
                params["birthday"] = birthday
            }
            return params
        case .LoginFacebook(token: let token):
            return ["access_token": token]
        case .SubmitArticle(title: let title, url: let url, vote: let vote):
            return ["article[title]": title, "article[url]": url, "vote": vote, "article[approved]": true]
        case .LoginGoogle(token: let token):
            return ["access_token": token]
        case .Vote(id: _, value: let value):
            return ["value": value]
        case .GetQueue(page: let page):
            return ["page": page]
        case .ListSubmited(userId: _, page: let page):
            return ["page": page]
        case .FavoriteArticles(page: let page):
            return ["page": page]
        case .UpdateArticle(id: _, approved: let approved):
            return ["article[approved]": approved]
        case .ForgotPass(email: let email):
            return ["email": email]
        case .ResetPass(token: let token, password: let password):
            return ["token": token, "password": password, "password_confirmation": password]
        default:
            break
        }
        return nil
    }
    
    var URLRequest: NSMutableURLRequest {
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = method.rawValue
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(mutableURLRequest, parameters: parameters).0
    }
    
}