//
//  StoryboardHelper.swift
//  DNews
//
//  Created by robert pham on 6/19/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardHelper {
    static func createInstance()-> UIViewController
}


protocol AuthenticationStoryboardInstance: StoryboardHelper {
    
}
extension AuthenticationStoryboardInstance {
    static func createInstance()-> UIViewController {
        return UIStoryboard(name: "Authentication", bundle: nil).instantiateViewControllerWithIdentifier(String(self.self))
    }
}
protocol MainStoryboardInstance: StoryboardHelper {
    
}
extension MainStoryboardInstance {
    static func createInstance()-> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(self.self))
    }
}
protocol HomeStoryboardInstance: StoryboardHelper {
    
}
extension HomeStoryboardInstance {
    static func createInstance()-> UIViewController {
        return UIStoryboard(name: "Home", bundle: nil).instantiateViewControllerWithIdentifier(String(self.self))
    }
}

protocol UserStoryboardInstance: StoryboardHelper {
    
}
extension UserStoryboardInstance {
    static func createInstance()-> UIViewController {
        return UIStoryboard(name: "User", bundle: nil).instantiateViewControllerWithIdentifier(String(self.self))
    }
}

protocol OtherStoryboardInstance: StoryboardHelper {
    
}
extension OtherStoryboardInstance {
    static func createInstance()-> UIViewController {
        return UIStoryboard(name: "Other", bundle: nil).instantiateViewControllerWithIdentifier(String(self.self))
    }
}