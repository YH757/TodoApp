//
//  TodoViewModel.swift
//  ToDo
//
//  Created by idol on 2025/7/16.
//

import Foundation
import Combine
import CoreData

class TodoViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    @Published var todos: [TodoItem] = []
    @Published var newTodoTitle = ""
    @Published var showAddTodo = false
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchTodos()
    }
    
    // 从 CoreData 获取所有 Todo 项
    func fetchTodos() {
        let request = TodoItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoItem.createdAt, ascending: false)]
        
        do {
            todos = try viewContext.fetch(request)
        } catch {
            print("Error fetching todos: \(error)")
        }
    }
    
    // 添加新 Todo 项
    func addTodo() {
        guard !newTodoTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newTodo = TodoItem(context: viewContext)
        newTodo.id = UUID()
        newTodo.title = newTodoTitle
        newTodo.createdAt = Date()
        newTodo.isCompleted = false
        
        saveContext()
        newTodoTitle = ""
        showAddTodo = false
    }
    
    // 更新 Todo 完成状态
    func toggleCompletion(for todo: TodoItem) {
        todo.isCompleted.toggle()
        saveContext()
    }
    
    // 删除 Todo 项
    func deleteTodo(_ todo: TodoItem) {
        viewContext.delete(todo)
        saveContext()
    }
    
    // 保存上下文到 CoreData
    private func saveContext() {
        do {
            try viewContext.save()
            fetchTodos()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}    
