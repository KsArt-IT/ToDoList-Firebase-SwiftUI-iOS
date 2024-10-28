//
//  DataRepositoryPreview.swift
//  ToDoList-SUI
//
//  Created by KsArT on 17.10.2024.
//

import Foundation
import Combine

final class DataRepositoryPreview: DataRepository {
    
    private var items: [ToDoItem] = []
    
    init() {
        previewData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
//            self?.updateSubject.send("")
        }
    }
    
    func fetchData() async -> Result<[ToDoItem], any Error> {
        .success(items)
    }
    
    func saveData(_ item: ToDoItem) async -> Result<Bool, any Error> {
        .success(true)
    }
    
    func deleteData(_ id: String) async -> Result<Bool, any Error> {
        .success(true)
    }
    
    private let updateSubject = PassthroughSubject<ToDoItem, Never>()
    public var updatePublisher: AnyPublisher<ToDoItem, Never> {
        updateSubject.eraseToAnyPublisher()
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
            items.append(item)
        }
    }
}
