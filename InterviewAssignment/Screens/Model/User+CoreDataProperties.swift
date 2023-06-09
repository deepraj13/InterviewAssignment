//
//  User+CoreDataProperties.swift
//  InterviewAssignment
//
//  Created by Deepraj Chowrasia on 09/06/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var country: String?
    @NSManaged public var registrationDate: String?
    @NSManaged public var pictureURL: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var postcode: String?
    @NSManaged public var dob: String?
    @NSManaged public var age: NSNumber?



}

extension User : Identifiable {

}
