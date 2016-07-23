//
//  String+Extension.swift
//  DNews
//
//  Created by robert pham on 6/20/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
                                             options: [.CaseInsensitive])
        
        return regex.firstMatchInString(self, options:[],
                                        range: NSMakeRange(0, utf16.count)) != nil
    }
}