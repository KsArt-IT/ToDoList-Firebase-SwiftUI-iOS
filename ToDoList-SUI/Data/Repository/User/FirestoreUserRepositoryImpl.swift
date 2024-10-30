//
//  FirestoreUserRepository.swift
//  ToDoList-SUI
//
//  Created by KsArT on 30.10.2024.
//

import Foundation
import FirebaseFirestore

final class FirestoreUserRepositoryImpl: UserRepository {
    
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func loadUser() async -> Result<UserData, any Error> {
        let result = await service.loadUser()
        switch result {
        case .success(let user):
            // получим фото, если есть
            let data: Data? = if !user.photoUrl.isEmpty {
                await service.fetchUserPhoto(url: user.photoUrl)
            } else {
                nil
            }
            return .success(user.mapToData(data))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func saveUser(user: UserData) async -> Result<Bool, any Error> {
        await service.saveUser(user: user.mapToDTO())
    }
    
}
