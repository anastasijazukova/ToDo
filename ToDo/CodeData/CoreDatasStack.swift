//
//  CoreDatasStack.swift
//  ToDo
//
//  Created by anastasija.zukova on 31/05/2020.
//  Copyright © 2020 Accenture. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "ToDo")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error \(error!)")
                return
            }
        }
        return container
    }
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
}
