//
//  HomeViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Foundation

@Observable
final class HomeViewModel {
    
    @ObservationIgnored private let router: Router
    @ObservationIgnored private let repository: DataRepository
    var list: [ToDoItem] = []
    
    var update = 0
    
    init(router: Router, repository: DataRepository) {
        print("HomeViewModel: \(#function)")
        self.router = router
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
                self.list = data
                self.update += 1
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    public func reload() {
        fetchData()
    }
    
    public func edit(id: String = "") {
        router.navigate(to: .edit(id: id))
    }
    
}
