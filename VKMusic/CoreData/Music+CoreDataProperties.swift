//
//  Music+CoreDataProperties.swift
//  VKMusic
//
//  Created by Robert on 12.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//
//

import Foundation
import CoreData


extension Music {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Music> {
        return NSFetchRequest<Music>(entityName: "Music")
    }

    @NSManaged public var title: String
    @NSManaged public var artist: String
    @NSManaged public var id: Int64
    @NSManaged public var duration: Int64
    @NSManaged public var url: String
    @NSManaged public var date: Int64
    @NSManaged public var ownerId: String


}
