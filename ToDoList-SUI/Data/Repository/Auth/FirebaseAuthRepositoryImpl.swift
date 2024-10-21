//
//  FirebaseAuthRepositoryImpl.swift
//  ToDoList-SUI
//
//  Created by KsArT on 21.10.2024.
//

import Foundation

final class FirebaseAuthRepositoryImpl: AuthRepository {

    private let service: AuthService

    init(service: AuthService) {
        self.service = service
    }

    func logout() async -> Result<Bool, Error> {
        await service.logout()
    }

    func fetchAuthUser() async -> Result<UserAuth, Error> {
        await service.fetchAuthUser()
    }

    func signIn(email: String, password: String) async -> Result<Bool, Error> {
        await service.signIn(email: email, password: password)
    }

    func signUp(email: String, password: String) async -> Result<Bool, Error> {
        await service.signUp(email: email, password: password)
    }

    func resetPassword(email: String) async -> Result<Bool, Error> {
        await service.resetPassword(email: email)
    }

    func signIn(withIDToken: String, accessToken: String) async -> Result<Bool, Error> {
        await service.signIn(withIDToken: withIDToken, accessToken: accessToken)
    }
}
