//
//  Music+CoreDataClass.swift
//  VKMusic
//
//  Created by Robert on 12.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//
//

import Foundation
import CoreData


class Music: NSManagedObject {
    convenience init(artist: String, title: String, url: String, duration: Int64, id: Int64) {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "Music"), insertInto: CoreDataManager.shared.persistentContainer.viewContext)
        
        self.artist = artist
        self.title = title
        self.url = url
        self.duration = duration
        self.id = id
    }
    
    
}
