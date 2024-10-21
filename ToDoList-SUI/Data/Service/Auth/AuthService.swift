//
//  AuthService.swift
//  ToDoList-SUI
//
//  Created by KsArT on 21.10.2024.
//

import Foundation

protocol AuthService {
    func logout() async -> Result<Bool, Error>
    func fetchAuthUser() async -> Result<UserAuth, Error>
    func signIn(email: String, password: String) async -> Result<Bool, Error>
    func signUp(email: String, password: String) async -> Result<Bool, Error>
    func resetPassword(email: String) async -> Result<Bool, Error>
    func signIn(withIDToken: String, accessToken: String) async -> Result<Bool, Error>
}
