//
//  FirestoreDataServiceImpl.swift
//  ToDoList-SUI
//
//  Created by KsArT on 25.10.2024.
//

import Foundation
import FirebaseFirestore
import Combine

final class FirestoreDataServiceImpl: DataService {
    
    private let updateSubject = PassthroughSubject<ToDoDTO, Never>()
    public var updatePublisher: AnyPublisher<ToDoDTO, Never> {
        updateSubject.eraseToAnyPublisher()
    }

    private lazy var db: Firestore? = {
        // [START setup]
        let settings = FirestoreSettings()
        // Set cache size to 100 MB
        settings.cacheSettings = PersistentCacheSettings(sizeBytes: 100 * 1024 * 1024 as NSNumber)
        Firestore.firestore().settings = settings
        // [END setup]
        return Firestore.firestore()
    }()
    
    // ссылка на коллекцию наших задач
    private var todoRef: CollectionReference? {
        guard let uid = Profile.user?.id else { return nil }
        
        return db?.collection(DB.Users.name).document(uid).collection(DB.Todos.name)
    }
    
    // ссылка на профиль пользователя
    private var userRef: DocumentReference? {
        guard let uid = Profile.user?.id else { return nil }
        
        return db?.collection(DB.Users.name).document(uid)
    }
    
    // получить коллекцию задач
    func fetchData() async -> Result<[ToDoDTO], any Error> {
        guard Profile.user != nil else { return .failure(NetworkServiceError.cancelled) }
        
        do {
            let snapshot = try await todoRef?.getDocuments()
            guard let snapshot else { return .failure(NetworkServiceError.invalidDatabase) }
            
            let todos = try snapshot.documents.compactMap { doc in
                try doc.data(as: ToDoDTO.self)
            }
            return .success(todos)
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
    }
    
    // записать задачу
    func saveData(_ item: ToDoDTO) async -> Result<Bool, any Error> {
        guard Profile.user != nil else { return .failure(NetworkServiceError.cancelled) }
        
        do {
            let doc = try todoRef?.addDocument(from: item)
            if let doc {
                updateSubject.send(
                    ToDoDTO(
                        id: doc.documentID,
                        date: item.date,
                        title: item.title,
                        text: item.text,
                        isCritical: item.isCritical,
                        isCompleted: item.isCompleted
                    )
                )
            }
            return .success(true)
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
    }
    
    // обновим задачу
    func updateData(_ item: ToDoDTO) async -> Result<Bool, any Error> {
        guard Profile.user != nil, let id = item.id else { return .failure(NetworkServiceError.cancelled) }
        
        do {
            _ = try todoRef?.document(id).setData(from: item, merge: true)
            updateSubject.send(item)
            return .success(true)
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
    }
    
    // удалим задачу
    func deleteData(_ id: String) async -> Result<Bool, any Error> {
        guard Profile.user != nil else { return .failure(NetworkServiceError.cancelled) }
        
        do {
            try await todoRef?.document(id).delete()
            return .success(true)
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
    }
}
