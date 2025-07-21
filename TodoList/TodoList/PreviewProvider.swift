//
//  PreviewProvider.swift
//  ToDo
//
//  Created by idol on 2025/7/16.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        return ContentView(context: context)
    }
}
