//
//  FirestoreDataRepository.swift
//  ToDoList-SUI
//
//  Created by KsArT on 28.10.2024.
//

import Foundation
import Combine

final class FirestoreDataRepositoryImpl: DataRepository {

    private let service: DataService
    
    var updatePublisher: AnyPublisher<ToDoItem, Never> {
        service.updatePublisher
            .map { $0.mapToItem() }
            .eraseToAnyPublisher()
    }
    
    init(service: DataService) {
        self.service = service
    }

    func fetchData() async -> Result<[ToDoItem], any Error> {
        let result = await service.fetchData()
        return switch result {
        case .success(let items):
                .success(items.map { $0.mapToItem() })
        case .failure(let error):
                .failure(error)
        }
    }
    
    func saveData(_ item: ToDoItem) async -> Result<Bool, any Error> {
        if !item.id.isEmpty {
            await service.updateData(item.mapToDto())
        } else {
            await service.saveData(item.mapToDto())
        }
    }
    
    func deleteData(_ id: String) async -> Result<Bool, any Error> {
        await service.deleteData(id)
    }
}
