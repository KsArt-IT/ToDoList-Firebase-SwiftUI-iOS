//
//  UserData.swift
//  ToDoList-SUI
//
//  Created by KsArT on 29.10.2024.
//

import Foundation

struct UserData: Hashable {
    var email: String
    var name: String
    var gender: Gender
    var age: Int
    var aboutMe: String
    var photoUrl: String
    var photoData: Data?
    
    // Task
    var taskCreated: Int
    var taskActive: Int
    var taskDeleted: Int
    var taskCompleted: Int
}

extension UserData {
    func mapToDTO() -> UserDTO {
        UserDTO(
            email: self.email,
            name: self.name,
            gender: self.gender.toString(),
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
    
    func toString() -> String {
        self.rawValue.key
    }
    
    static func instance(_ key: String) -> Gender {
        switch key {
        case "male", male.rawValue.key: .male
        case "female", female.rawValue.key: .female
        case "other", other.rawValue.key: .other
        default: .male
        }
    }
}

enum Statistics {
    case created
    case active
    case deleted
    case completed
}
