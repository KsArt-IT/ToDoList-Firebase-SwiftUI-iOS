//
//  HomeViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Foundation

@Observable
final class HomeViewModel {
    
    @ObservationIgnored private let repository: DataRepository
    @ObservationIgnored private var items: [ToDoItem] = []
    var list:[ToDoItem] {
        items
    }
    
    var update = 0
    
    init(repository: DataRepository) {
        print(#function)
        self.repository = repository
        
        fetchData()
    }
    
    private func fetchData() {
        print(#function)
        Task { [weak self] in
            guard let self else { return }
            
            let result = await self.repository.fetchData()
            switch result {
            case .success(let data):
                self.items = data
                self.update += 1
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
