//
//  LocalDataRopositoryImpl.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Foundation
import Combine

final class LocalDataRopositoryImpl: DataRepository {
    private let service: DataService
    
    var updatePublisher: AnyPublisher<String, Never> { service.updatePublisher }

    init(service: DataService) {
        self.service = service
    }
    
    func fetchData() async -> Result<[ToDoItem], any Error> {
        await service.fetchData()
    }
    
    func fetchData(_ id: String) async -> Result<ToDoItem?, any Error> {
        await service.fetchData(id)
    }
    
    func saveData(_ item: ToDoItem) async -> Result<Bool, any Error> {
        if item.id.isEmpty {
            await service.saveData(item.copy(id: UUID().uuidString))
        } else {
            await service.updateData(item)
        }
    }
    
    func deleteData(_ id: String) async -> Result<Bool, any Error> {
        await service.deleteData(id)
    }
    
}


