//
//  Dialog+CoreDataClass.swift
//  VKMusic
//
//  Created by Robert on 15.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//
//

import Foundation
import CoreData


class Dialog: NSManagedObject {
    convenience init(firstName: String, lastName: String?, id: Int64, photo: NSData?, randomId: Int64) {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "Dialog"), insertInto: CoreDataManager.shared.persistentContainer.viewContext)
        
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.photo = photo
        self.randomId = randomId
    }
}
