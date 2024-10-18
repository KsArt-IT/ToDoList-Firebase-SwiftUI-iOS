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
        let result = await service.fetchData()
        return switch result {
        case .success(let items):
                .success(items.map { $0.mapToItem() })
        case .failure(let error):
                .failure(error)
        }
    }
    
    func fetchData(_ id: String) async -> Result<ToDoItem?, any Error> {
        let result = await service.fetchData(id)
        return switch result {
        case .success(let item):
                .success(item?.mapToItem())
        case .failure(let error):
                .failure(error)
        }
    }
    
    func saveData(_ item: ToDoItem) async -> Result<Bool, any Error> {
        let item = if item.id.isEmpty { item.copy(id: UUID().uuidString) } else { item }
        return await service.saveData(item.mapToDto())
    }
    
    func deleteData(_ id: String) async -> Result<Bool, any Error> {
        await service.deleteData(id)
    }
    
}


