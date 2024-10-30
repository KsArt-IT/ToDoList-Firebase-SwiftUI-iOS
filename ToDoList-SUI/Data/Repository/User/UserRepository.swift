//
//  UserRepository.swift
//  ToDoList-SUI
//
//  Created by KsArT on 30.10.2024.
//

import Foundation

protocol UserRepository: AnyObject {
    func loadUser() async -> Result<UserData, any Error>
    func saveUser(user: UserData) async -> Result<Bool, any Error>
}
