//
//  ToDoList_SUIApp.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI
import SwiftData

@main
struct ToDoList_SUIApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ToDoTable.self)
        }
    }
}
