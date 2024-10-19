//
//  UserAuth.swift
//  ToDoList-SUI
//
//  Created by KsArT on 19.10.2024.
//

import Foundation

struct UserAuth {
    let id: String
    let token: String
    let refreshToken: String
    let name: String
    let email: String
    let photoUrl: String?
    let photo: Data?
    let date: Date
}
