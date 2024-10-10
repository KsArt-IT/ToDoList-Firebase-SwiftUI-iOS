//
//  ToDoItem.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//


import Foundation
import SwiftData

@Model
final class ToDoTable: Identifiable, Equatable {
    var id: String
    var date: Date
    var title: String
    var text: String
    var isCritical: Bool
    var isCompleted: Bool
    var synchronized: Date?

    init(
        id: String,
        date: Date,
        title: String,
        text: String,
        isCritical: Bool,
        isCompleted: Bool,
        synchronized: Date? = nil
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.text = text
        self.isCritical = isCritical
        self.isCompleted = isCompleted
        
        self.synchronized = synchronized
    }
}
