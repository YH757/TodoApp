//
//  ContentView.swift
//  TodoList
//
//  Created by idol on 2025/7/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: TodoViewModel
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        _viewModel = StateObject(wrappedValue: TodoViewModel(context: context))
    }

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            //            List {
            //                ForEach(items) { item in
            //                    NavigationLink {
            //                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
            //                    } label: {
            //                        Text(item.timestamp!, formatter: itemFormatter)
            //                    }
            //                }
            //                .onDelete(perform: deleteItems)
            //            }
            VStack {
                if viewModel.todos.isEmpty {
                    emptyStateView
                } else {
                    todoListView
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {viewModel.showAddTodo = true }) {
                        Label("Add Todo", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddTodo) {
                AddTodoView(viewModel: viewModel)
            }
        }
    }
               
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No todos yet!")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to add your first task.")
                .foregroundColor(.gray)
            
            Button(action: {
                viewModel.showAddTodo = true
            }) {
                Text("Add Todo")
                    .fontWeight(.medium)
                    .padding()
                    .padding(.horizontal, 20)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private var todoListView: some View {
        List {
            ForEach(viewModel.todos) { todo in
                TodoRowView(todo: todo) {
                    viewModel.toggleCompletion(for: todo)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private func deleteItems(offsets: IndexSet) {
        offsets.map { viewModel.todos[$0] }.forEach(viewModel.deleteTodo)
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.system(size: 22))
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .gray : .primary)
            
            Spacer()
            
            Text(formatDate(todo.createdAt))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter todo title", text: $viewModel.newTodoTitle)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    viewModel.addTodo()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(viewModel.newTodoTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                
                Spacer()
            }
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .padding(.top, 20)
        }
    }
}

