//
//  TodoItem.swift
//  ToDo
//
//  Created by idol on 2025/7/16.
//

import Foundation
import CoreData

@objc(TodoItem)
public class TodoItem: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var createdAt: Date
    @NSManaged public var isCompleted: Bool
}

extension TodoItem {
    static func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }
}    
