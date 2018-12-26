//
//  CountryModel.swift
//  Contacts app
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Yogesh Makhija. All rights reserved.
//

import Foundation

class Country: NSObject {
    
    var countryName = ""
    var countryCode = ""
    
    override init() {
        super.init()
    }
    
    init(countryName: String,countryCode:String){
        self.countryName = countryName
        self.countryCode = countryCode
    }
}
