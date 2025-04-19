//
//  PersistenceController.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-15.
//
import Foundation
import CoreData
// MARK: PersistenceController
/*
 Manages the Core Data stack for the app using a shared NSPersistenceController.
 Provides an option to run in-memory for testing or previews.
 */
struct PersistenceController {
    // Singleton instance for global access
    static let shared = PersistenceController()
    // Core Data persistent container
    let container: NSPersistentContainer
    /*
     Initializes the Core Data stack.
     - If inMemory is true, data is stored in RAM for temporary use.
     */
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RecipePalModel")
        if inMemory {
            // Redirects storage to a null location for in-memory use
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            // Handle loading errors
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
