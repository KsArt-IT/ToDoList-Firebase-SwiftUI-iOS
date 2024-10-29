//
//  UserData.swift
//  ToDoList-SUI
//
//  Created by KsArT on 29.10.2024.
//

import Foundation

struct UserData {
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

enum Gender: LocalizedStringResource {
    case male = "male"
    case female = "female"
    case other = "other"
}
