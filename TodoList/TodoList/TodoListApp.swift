//
//  TodoListApp.swift
//  TodoList
//
//  Created by idol on 2025/7/21.
//

import SwiftUI

@main
struct TodoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
