//
//  UserDTO.swift
//  ToDoList-SUI
//
//  Created by KsArT on 30.10.2024.
//

import Foundation
import FirebaseFirestore

struct UserDTO: Identifiable, Codable {
    @DocumentID
    var id: String?
    let name: String
    let gender: Gender
    let age: Int
    let aboutMe: String
    let photoUrl: String
    
    // Task
    let taskCreated: Int
    let taskActive: Int
    let taskDeleted: Int
    let taskCompleted: Int
}

extension UserDTO {
    func mapToData(_ photoData: Data?) -> UserData {
        UserData(
            name: self.name,
            gender: self.gender,
            age: self.age,
            aboutMe: self.aboutMe,
            photoUrl: self.photoUrl,
            photoData: photoData,
            
            taskCreated: self.taskCreated,
            taskActive: self.taskActive,
            taskDeleted: self.taskDeleted,
            taskCompleted: self.taskCompleted
        )
    }
    
    func trasformToDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        dictionary["name"] = self.name
        dictionary["gender"] = self.gender
        dictionary["age"] = self.age
        dictionary["aboutMe"] = self.aboutMe
        dictionary["photoUrl"] = self.photoUrl
        
        dictionary["taskCreated"] = self.taskCreated
        dictionary["taskActive"] = self.taskActive
        dictionary["taskDeleted"] = self.taskDeleted
        dictionary["taskCompleted"] = self.taskCompleted
        
        return dictionary
    }
}
