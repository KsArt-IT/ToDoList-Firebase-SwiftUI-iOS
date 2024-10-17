//
//  DBLocal.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Foundation
import Combine

final class LocalDataServiceImpl: DataService {
    
    private var items: [String: ToDoItem] = [:]
    private let updateSubject = PassthroughSubject<String, Never>()
    public var updatePublisher: AnyPublisher<String, Never> {
        updateSubject.eraseToAnyPublisher()
    }
    
    init() {
//        previewData()
    }
    
    func fetchData() async -> Result<[ToDoItem], any Error> {
        return .success(Array(items.values))
    }
    
    func fetchData(_ id: String) async -> Result<ToDoItem?, any Error> {
        .success(items[id])
    }
    
    func saveData(_ item: ToDoItem) async -> Result<Bool, any Error> {
        items[item.id] = item
        updateSubject.send(item.id)
        return .success(true)
    }
    
    func updateData(_ item: ToDoItem) async -> Result<Bool, any Error> {
        await saveData(item)
    }
    
    func deleteData(_ id: String) async -> Result<Bool, any Error> {
        items.removeValue(forKey: id)
        return .success(true)
    }
    
    private func previewData() {
        (0...100).forEach { num in
            let item = ToDoItem(
                id: num.description,
                date: Date(),
                title: "Element-\(num)",
                text: "Go to",
                isCritical: num % 2 == 0,
                isCompleted: num % 5 == 0
            )
            items[item.id] = item
        }
    }

}
