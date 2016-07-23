//
//  AppError.swift
//  DNews
//
//  Created by robert pham on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

enum AppErrorCode: Int {
    case DefaultCode = 6900
    
    func message() -> String {
        switch self {
        case .DefaultCode:
            return "Something's wrong"
        }
    }
}

class AppError {
    
    var domain: String = "com.dnews.defaulDomain"
    var code: AppErrorCode = .DefaultCode
    var failureReason = "Something's wrong!"
    
    init () {
        
    }
    
    init(appCode: AppErrorCode) {
        code = appCode
        self.failureReason = code.message()
    }
    
    init(domain: String, code: AppErrorCode, reason: String) {
        self.domain = domain
        self.code = code
        self.failureReason = reason
    }
    
    class func appError(error: NSError?)-> AppError {
        let appError = AppError()
        if let _ = error {
            appError.failureReason = error!.localizedDescription
        }
        return appError
    }
}