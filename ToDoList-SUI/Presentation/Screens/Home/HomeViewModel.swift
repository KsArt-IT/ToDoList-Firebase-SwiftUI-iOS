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
    
    private var taskLoadData: Task<(), Never>?
    private var timeLoadData: Date?
    private let timeDelay: TimeInterval = 20
    
    init(router: Router, repository: DataRepository) {
        print("HomeViewModel: \(#function)")
        self.router = router
        self.repository = repository
    }
    
    public func reloadData() {
        // вызывать каждый раз
        fetchData()
    }
    
    public func loadData() {
        // не чаще раз в x сек
        guard timeLoadData == nil || Date().timeIntervalSince(timeLoadData!) > timeDelay else { return }
        fetchData()
    }
    
    private func fetchData() {
        print(#function)
        if taskLoadData != nil {
            taskLoadData?.cancel()
        }
        taskLoadData = Task { [weak self] in
            guard let self else { return }
            
            let result = await self.repository.fetchData()
            switch result {
            case .success(let data):
                self.list = data
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            taskLoadData = nil
            timeLoadData = Date()
        }
    }
    
    public func edit(id: String = "") {
        router.navigate(to: .edit(id: id))
    }
    
}
