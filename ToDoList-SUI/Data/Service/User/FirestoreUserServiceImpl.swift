//
//  FirestoreUserServiceImpl.swift
//  ToDoList-SUI
//
//  Created by KsArT on 30.10.2024.
//

import Foundation
import FirebaseFirestore

final class FirestoreUserServiceImpl: UserService {
    
    private lazy var db: Firestore? = {
        Firestore.firestore()
    }()
    
    // ссылка на профиль пользователя
    private var userRef: DocumentReference? {
        guard let uid = Profile.user?.id else { return nil }
        
        return db?.collection(DB.Users.name).document(uid)
    }
    
    // MARK: - Network operation
    func loadUser() async -> Result<UserDTO, any Error> {
        guard Profile.user != nil else { return .failure(NetworkServiceError.cancelled) }
        
        do {
            let user = try await userRef?.getDocument(as: UserDTO.self)
            guard let user else { return .failure(NetworkServiceError.invalidDatabase) }
            
            return .success(user)
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
        
    }
    
    func saveUser(user: UserDTO) async -> Result<Bool, any Error> {
        guard Profile.user != nil else { return .failure(NetworkServiceError.cancelled) }
        
        do {
            try await userRef?.setData(user.trasformToDictionary(), merge: true)
            
            return .success(true)
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
        
    }
    
    func fetchUserPhoto(url: String) async -> Data? {
        guard let url = URL(string: url) else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return if checkResponse(response) {
                data
            } else {
                nil
            }
        } catch {
            return nil
        }
    }
    
    private func checkResponse(_ response: URLResponse) -> Bool {
        if let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode { true } else { false }
    }
    
}
