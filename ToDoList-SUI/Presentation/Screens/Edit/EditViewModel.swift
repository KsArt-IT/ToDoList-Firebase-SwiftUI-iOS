//
//  EditViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 15.10.2024.
//

import SwiftUI

@Observable
final class EditViewModel {
    
    @ObservationIgnored private let repository: DataRepository
    
    var item: ToDoItem?
    var isClose = false
    
    init(repository: DataRepository) {
        print(#function)
        self.repository = repository
    }
    
    public func getItem(_ id: String) {
        if id.isEmpty {
            item = getNewItem()
        } else {
            loadItem(id)
        }
    }
    
    public func save() {
        guard let item else { return }
        
        Task { [weak self] in
            let result = await self?.repository.saveData(item)
            switch result {
            case .success(_):
                self?.isClose = true
            case .failure(let error):
                print("Error: \(error)")
            case .none:
                break
            }
        }
    }
    
    private func loadItem(_ id: String) {
        Task { [weak self] in
            let result = await self?.repository.fetchData(id)
            switch result {
            case .success(let item):
                self?.item = item
            case .failure(let error):
                print("Error: \(error)")
            case .none:
                break
            }
        }
    }
    
    private func getNewItem() -> ToDoItem {
        ToDoItem(id: UUID().uuidString, date: Date(), title: "", text: "", isCritical: false, isCompleted: false)
    }
}
