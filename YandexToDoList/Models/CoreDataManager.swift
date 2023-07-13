//
//  CoreDataManager.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 13.07.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoItemList")
        container.loadPersistentStores(completionHandler: {_, error in
            _ = error.map { fatalError("Unresolved error \($0)") }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
