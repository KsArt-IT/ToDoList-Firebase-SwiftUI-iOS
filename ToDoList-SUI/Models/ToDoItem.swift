//
//  ToDoItem.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import Foundation

struct ToDoItem: Identifiable, Hashable, Comparable {
    let id: String
    let date: Date
    let title: String
    let text: String
    let isCritical: Bool
    let isCompleted: Bool
    
    let timeMin: Int?
}

extension ToDoItem {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.date, lhs.title, lhs.text, lhs.isCompleted, lhs.timeMin) == (rhs.date, rhs.title, rhs.text, rhs.isCompleted, lhs.timeMin)
    }
    
    // Реализуем оператор меньше для сравнения задач по дате
    static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.date, lhs.title, lhs.text) < (rhs.date, rhs.title, rhs.text)
    }
}

extension ToDoItem {
    func mapToDto() -> ToDoDTO {
        ToDoDTO(
            id: self.id,
            date: self.date,
            title: self.title,
            text: self.text,
            isCritical: self.isCritical,
            isCompleted: self.isCompleted
        )
    }
    
    func copy(id: String? = nil, date: Date? = nil, title: String? = nil, text: String? = nil, isCritical: Bool? = nil, isCompleted: Bool? = nil, timeMin: Int? = nil) -> Self {
        ToDoItem(
            id: id ?? self.id,
            date: date ?? self.date,
            title: title ?? self.title,
            text: text ?? self.text,
            isCritical: isCritical ?? self.isCritical,
            isCompleted: isCompleted ?? self.isCompleted,
            
            timeMin: timeMin ?? self.timeMin
        )
    }
    
    func isActive() -> Bool {
        self.timeMin != nil && self.timeMin! > -Constants.timeInterval
    }
}
