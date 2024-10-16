//
//  EditViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 15.10.2024.
//

import SwiftUI

@Observable
final class EditViewModel {
    
    @ObservationIgnored private let router: Router
    @ObservationIgnored private let repository: DataRepository
    
    var item: ToDoItem?
    
    init(router: Router, repository: DataRepository) {
        print("EditViewModel: \(#function)")
        self.router = router
        self.repository = repository
    }
    
    public func getItem(_ id: String) {
        guard item == nil else { return }
        
        print("EditViewModel: \(#function): \(id)")
        if id.isEmpty {
            item = getNewItem()
        } else {
            loadItem(id)
        }
    }
    
    public func save() {
        print("EditViewModel: \(#function)")
        guard let item else { return }
        
        Task { [weak self] in
            let result = await self?.repository.saveData(item)
            self?.toBack()
            switch result {
            case .success(_):
                self?.toBack()
            case .failure(let error):
                print("Error: \(error)")
                self?.toBack()
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
    
    // MARK: - Nagigation
    
    private func toBack() {
        print(#function)
        router.back()
//        DispatchQueue.main.async { [weak self] in
//            self?.router.back()
//        }
    }
}
