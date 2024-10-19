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
    
    @ObservationIgnored private var taskLoadData: Task<(), Never>?
    @ObservationIgnored private var timeLoadData: Date?
    @ObservationIgnored private let timeDelay: TimeInterval = 20
    
    var list: [ToDoItem] = []
    var done: Double {
        list.count > 0 ? Double(list.count(where: { $0.isCompleted })) / Double(list.count) : 0
    }
    
    init(router: Router, repository: DataRepository) {
        print("HomeViewModel: \(#function)")
        self.router = router
        self.repository = repository
        // наблюдаем за добавлением и изменением записей
        subscribeUpdate()
    }

    public func toggleCompleted(_ id: String) {
        guard let item = list.first(where: { $0.id == id }) else { return }
        
        Task { [weak self] in
            let result = await self?.repository.saveData(item.copy(isCompleted: !item.isCompleted))
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
                self?.updateList(item)
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
    
    private func isAuthorized() -> Bool {
        if Profile.isRelogin {
            toLogin()
        }
        return !Profile.isRelogin
    }
    
    private func fetchData() {
        print(#function)
        guard isAuthorized() else { return }
        
        if taskLoadData != nil {
            taskLoadData?.cancel()
        }
        taskLoadData = Task { [weak self] in
            guard let self else { return }
            
            let result = await self.repository.fetchData()
            switch result {
            case .success(let data):
                self.sortList(data)
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
    
    private func loadData(by id: String) {
        guard !id.isEmpty else {
            loadData()
            return
        }
        
        Task { [weak self] in
            let result = await self?.repository.fetchData(id)
            switch result {
            case .success(let item):
                guard let item else { break }
                self?.updateList(item)
            case .failure(let error):
                self?.showError(error)
            case .none:
                break
            }
        }
    }
    
    private func updateList(_ newItem: ToDoItem) {
        var newList = list.filter { $0.id != newItem.id }
        newList.append(newItem)
        sortList(newList)
    }

    private func sortList(_ newList: [ToDoItem]) {
        guard isAuthorized() else { return }
        
        self.list = newList.sorted(by: <)
    }

    private func showError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    private func subscribeUpdate() {
        repository.updatePublisher
            .sink(receiveValue: loadData)
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    private func toLogin() {
        router.navigateToRoot()
    }

}
