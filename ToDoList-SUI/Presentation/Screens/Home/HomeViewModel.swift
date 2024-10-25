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
    @ObservationIgnored private var isInitialize = false
    
    var list: [ToDoItem] = []
    // отображение прогресса выполненных задач
    var progressCompleted: Double {
        list.count > 0 ? Double(list.count(where: { $0.isCompleted })) / Double(list.count) : 0
    }
    @ObservationIgnored private var isEdit = false
    // отображение тостов и алертов
    var toastMessage = ""
    var alertMessage: AlertModifier.AlertType = ("", false)

    init(router: Router, repository: DataRepository) {
        print("HomeViewModel: \(#function)")
        self.router = router
        self.repository = repository

        // наблюдаем за добавлением и изменением записей
        self.subscribeUpdate()
    }
    
    public func onShowView() {
        print("HomeViewModel: \(#function)")
        guard Profile.isInitialized else { return }
        guard isAuthorized() else { return }
        guard !isEdit else {
            isEdit = false
            return
        }
        
        loadData()
    }
    
    private func isAuthorized() -> Bool {
        if Profile.isRelogin {
            toLogin()
        }
        return !Profile.isRelogin
    }
    
    public func logout() {
        Profile.logout()
        toLogin()
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
    
    private func fetchData() {
        guard isAuthorized() else { return }
        print("HomeViewModel: \(#function)")
        
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
        guard let error = error as? NetworkServiceError else {
            showAlert(error.localizedDescription, isError: true)
            return
        }
        print("Error: \(error.localizedDescription)")
        switch error {
        case .cancelled:
            break
        default:
            showToast(error.localizedDescription)
        }
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
    }
    
    private func showAlert(_ message: String, isError: Bool = false) {
        alertMessage = (message, isError)
    }
    
    private func subscribeUpdate() {
        repository.updatePublisher
            .sink(receiveValue: loadData)
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    public func edit(id: String = "") {
        guard isAuthorized() else { return }
        isEdit = true
        
        router.navigate(to: .edit(id: id))
    }
    
    private func toLogin() {
        print("HomeViewModel: \(#function)")
        router.navigate(to: .login)
    }
    
}
