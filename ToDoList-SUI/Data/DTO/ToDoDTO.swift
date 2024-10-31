//
//  ToDoDTO.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import Foundation
import FirebaseFirestore

struct ToDoDTO: Identifiable, Codable {
    @DocumentID
    var id: String?
    let date: Date
    let title: String
    let text: String
    let isCritical: Bool
    let isCompleted: Bool
}

extension ToDoDTO {
    func mapToItem() -> ToDoItem {
        ToDoItem(
            id: self.id ?? "",
            date: self.date,
            title: self.title,
            text: self.text,
            isCritical: self.isCritical,
            isCompleted: self.isCompleted,
            
            timeMin: nil
        )
    }
}
