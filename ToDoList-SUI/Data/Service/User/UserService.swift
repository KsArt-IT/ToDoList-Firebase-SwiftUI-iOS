//
//  UserService.swift
//  ToDoList-SUI
//
//  Created by KsArT on 30.10.2024.
//

import Foundation

protocol UserService: AnyObject {
    func loadUser() async -> Result<UserDTO, any Error>
    func saveUser(user: UserDTO) async -> Result<Bool, any Error>
    func fetchUserPhoto(url: String) async -> Data?
}
