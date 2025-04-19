//
//  RecipePalApp.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-15.
//
import SwiftUI
import Firebase
// MARK: RecipePalApp Entry Point
/*
 Main entry point of the app.
 Sets up the environment with Core Data's managed object context.
 */
@main
struct RecipePalApp: App {
    // Shared Core Data stack
    let persistenceController = PersistenceController.shared
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Inject Core Data context into environment
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
