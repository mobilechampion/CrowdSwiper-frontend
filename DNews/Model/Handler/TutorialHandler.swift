//
//  TutorialHandler.swift
//  DNews
//
//  Created by robert pham on 7/12/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
private let showKey = "com.dnews.showedTutorial"

class TutorialHandler {
    
    class func needShow()-> Bool {
        let showed = NSUserDefaults.standardUserDefaults().boolForKey(showKey)
        return !showed
    }
    
    class func setShowed() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: showKey)
    }
    
}