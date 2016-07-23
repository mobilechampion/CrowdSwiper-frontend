//
//  APIManager.swift
//  DNews
//
//  Created by robert pham on 6/19/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias CompletionHandlerBlock = (success: Bool, error: AppError?)-> Void

class APIManager {
    
    static let sharedInstance: APIManager = {
        return APIManager()
    }()
    
    var manager: Alamofire.Manager!
    
    init() {
        loadToken()
    }
    
    func loadToken() {
        
        configManager(UserManager.sharedInstance.userToken)
    }
    
    private func configManager(token: UserToken?) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 30
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        
        if let token = token {
            defaultHeaders["access-token"] = token.accessToken
            if let _ = token.client {
                defaultHeaders["client"] = token.client
            }
            if let _ = token.uid {
                defaultHeaders["uid"] = token.uid
            }
            defaultHeaders["expiry"] = token.expiry
        }
        
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        manager = Alamofire.Manager(configuration: configuration)
        
    }
    
    func requestDataForRouter(router: APIRouter, completion:(json: JSON?, error: AppError?)->Void) {
        manager.request(router).responseData { (res) in
            if res.result.isSuccess {
                print(String(data: res.data!, encoding: NSUTF8StringEncoding))
                let mJson = JSON(data: res.data!)
                let status = mJson["status"].stringValue
                if status == "success" {
                    completion(json: mJson, error: nil)
                } else {
                    let msg = mJson["errors"]["full_messages"].stringValue
                    let err = AppError()
                    err.failureReason = msg.isEmpty == false ? msg : "Request failed. Please try again"
                    completion(json: nil, error: err)
                }
                
            } else {
                let appError = AppError.appError(res.result.error)
                completion(json: nil, error: appError)
            }
        }
    }
    
    func requestAuthenRouter(router: APIRouter, completion:(json: JSON?, error: AppError?)->Void) {
        APIManager.sharedInstance.manager.request(router).responseData { (res) in
            if res.result.isSuccess {
                print(String(data: res.data!, encoding: NSUTF8StringEncoding))
                print(res.response?.allHeaderFields)
                let mJson = JSON(data: res.data!)
                let status = mJson["status"].stringValue
                if status == "success" {
                    // save user token
                    UserToken.saveWithHeaders(res.response?.allHeaderFields)
                    completion(json: mJson, error: nil)
                } else {
                    let msg = mJson["errors"]["full_messages"].stringValue
                    let err = AppError()
                    err.failureReason = msg
                    completion(json: nil, error: err)
                }
                
            } else {
                let appError = AppError.appError(res.result.error)
                completion(json: nil, error: appError)
            }
        }
    }
    
    
}