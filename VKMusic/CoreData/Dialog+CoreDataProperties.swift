//
//  Dialog+CoreDataProperties.swift
//  VKMusic
//
//  Created by Robert on 15.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//
//

import Foundation
import CoreData


extension Dialog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dialog> {
        return NSFetchRequest<Dialog>(entityName: "Dialog")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var id: Int64
    @NSManaged public var firstName: String
    @NSManaged public var photo: NSData?
    @NSManaged public var randomId: Int64
    

}
