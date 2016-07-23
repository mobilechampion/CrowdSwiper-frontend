//
//  UserModel.swift
//  DNews
//
//  Created by robert pham on 7/2/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserModel {
    
    var email = ""
    var name = ""
    var nickname = ""
    var imageUrl = ""
    var thumbnail = ""
    
    init(json: JSON) {
        email = json["email"].stringValue
        name = json["name"].stringValue
        nickname = json["nickname"].stringValue
        imageUrl = json["image"]["image"]["url"].stringValue
        thumbnail = json["image"]["thumbnail"]["url"].stringValue
    }
    
}
