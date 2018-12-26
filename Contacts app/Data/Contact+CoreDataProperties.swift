//
//  Contact+CoreDataProperties.swift
//  Contacts app
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Yogesh Makhija. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var email: String?
    @NSManaged public var nationality: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var fullName: String?
    @NSManaged public var image: NSData?

}
