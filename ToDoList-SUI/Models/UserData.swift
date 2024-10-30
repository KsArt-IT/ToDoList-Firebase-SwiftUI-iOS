//
//  UserData.swift
//  ToDoList-SUI
//
//  Created by KsArT on 29.10.2024.
//

import Foundation

struct UserData: Hashable {
    let name: String
    let gender: Gender
    let age: Int
    let aboutMe: String
    let photoUrl: String
    let photoData: Data?
    
    // Task
    let taskCreated: Int
    let taskActive: Int
    let taskDeleted: Int
    let taskCompleted: Int
}

extension UserData {
    func mapToDTO() -> UserDTO {
        UserDTO(
            name: self.name,
            gender: self.gender,
            age: self.age,
            aboutMe: self.aboutMe,
            photoUrl: self.photoUrl,
            
            taskCreated: self.taskCreated,
            taskActive: self.taskActive,
            taskDeleted: self.taskDeleted,
            taskCompleted: self.taskCompleted
        )
    }
}

enum Gender: LocalizedStringResource, Codable {
    case male = "male"
    case female = "female"
    case other = "other"
}
