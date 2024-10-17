//
//  HomeViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Foundation
import Combine

@Observable
final class HomeViewModel {
    
    @ObservationIgnored private let router: Router
    @ObservationIgnored private let repository: DataRepository
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    
    var list: [ToDoItem] = []
    
    private var taskLoadData: Task<(), Never>?
    private var timeLoadData: Date?
    private let timeDelay: TimeInterval = 20
    
    init(router: Router, repository: DataRepository) {
        print("HomeViewModel: \(#function)")
        self.router = router
        self.repository = repository
        subscribeUpdate()
    }
    
    public func toggleCompleted(_ id: String) {
        guard let index = list.firstIndex(where: { $0.id == id }) else { return }
        var item = list[index]
        item = item.copy(isCompleted: !item.isCompleted)
        list[index] = item
        print("\(#function) completed=\(item.isCompleted)")
        Task { [weak self] in
            let result = await self?.repository.saveData(item)
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self?.showError(error)
            case .none:
                break
            }
        }
    }
    
    public func delete(_ set: IndexSet) {
        guard !set.isEmpty else { return }
        
        set.forEach { delete($0) }
    }
    
    private func delete(_ index: Int) {
        let item = list.remove(at: index)
        Task { [weak self] in
            let result = await self?.repository.deleteData(item.id)
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self?.list.append(item)
                self?.showError(error)
            case .none:
                break
            }
        }
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
                self.showError(error)
            }
            self.taskLoadData = nil
            self.timeLoadData = Date()
        }
    }
    
    public func edit(id: String = "") {
        router.navigate(to: .edit(id: id))
    }
    
    private func subscribeUpdate() {
        repository.updatePublisher
            .sink(receiveValue: loadData)
            .store(in: &cancellables)
    }
    
    private func loadData(by id: String) {
        print("HomeViewModel: \(#function) id='\(id)'")
        guard !id.isEmpty else {
            loadData()
            return
        }
        
        Task { [weak self] in
            let result = await self?.repository.fetchData(id)
            switch result {
            case .success(let item):
                guard let item else { break }
                self?.updateItem(item)
            case .failure(let error):
                self?.showError(error)
            case .none:
                break
            }
        }
    }
    
    private func updateItem(_ item: ToDoItem) {
        print("\(#function) completed=\(item.isCompleted)")
        if let index = list.firstIndex(where: { $0.id == item.id }) {
            list[index] = item
        } else {
            list.append(item)
        }
    }
    
    private func showError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
