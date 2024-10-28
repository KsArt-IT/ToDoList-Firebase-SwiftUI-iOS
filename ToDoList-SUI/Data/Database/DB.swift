//
//  DB.swift
//  ToDoList-SUI
//
//  Created by KsArT on 25.10.2024.
//


import Foundation

enum DB {
    
    enum Todo {
        static let name = "todo"
        
        enum Fields {
            static let date = "date"
        }
    }
    
    enum Users {
        static let name = "users"
    }
}
