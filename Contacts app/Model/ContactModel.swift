//
//  ContactModel.swift
//  Contacts app
//
//  Created by apple on 25/12/18.
//  Copyright © 2018 Yogesh Makhija. All rights reserved.
//

import Foundation

class ContactModel: NSObject {
    
    var firstName = ""
    var lastName = ""
    var emailAddress = ""
    var phoneNumber = ""
    var nationality = ""
    
    override init() {
        super.init()
    }
    
    init(firstName:String, lastName:String, emailAddress:String, phoneNumber:String, nationality:String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.nationality = nationality
    }
    
}
