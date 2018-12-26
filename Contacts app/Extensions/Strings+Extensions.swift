//
//  Strings+Extensions.swift
//  Contacts app
//
//  Created by apple on 25/12/18.
//  Copyright © 2018 Yogesh Makhija. All rights reserved.
//

import Foundation

extension String {
    
    /// Validate Email address
    var isValidEmail: Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        }
        catch {
            return false
        }
    }
    
    func validateMobile(value: String) -> Bool {
//        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
}
