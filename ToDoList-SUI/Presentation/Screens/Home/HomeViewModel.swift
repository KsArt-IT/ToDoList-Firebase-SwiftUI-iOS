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
    @ObservationIgnored private let userRepository: UserRepository
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
    
    @ObservationIgnored private var profile: UserData?
    
    init(router: Router, repository: DataRepository, userRepository: UserRepository) {
        print("HomeViewModel: \(#function)")
        self.router = router
        self.repository = repository
        self.userRepository = userRepository
        
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
        if profile == nil {
            loadProfile()
        }
    }
    
    // MARK: - Profile
    private func loadProfile() {
        Task {
            let result = await userRepository.loadUser()
            switch result {
            case .success(let user):
                profile = user
            case .failure(let error):
                switch error {
                case NetworkServiceError.profileNotInitialized:
                    initProfile()
                default:
                    print("HomeViewModel: \(#function) error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func saveProfile() {
        print("HomeViewModel: \(#function)")
        guard let profile else { return }
        
        Task {
            let result = await userRepository.saveUser(user: profile)
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print("HomeViewModel: \(#function) error: \(error.localizedDescription)")
            }
        }
    }
    
    private func initProfile() {
        guard profile == nil, let userData = Profile.user else { return }
        
        let user = UserData(
            email: userData.email,
            name: userData.name,
            gender: Gender.male,
            age: 0,
            aboutMe: "",
            photoUrl: userData.photoUrl ?? "",
            
            taskCreated: 0,
            taskActive: 0,
            taskDeleted: 0,
            taskCompleted: 0
        )
        profile = user
        saveProfile()
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
    
    public func delete(by id: String) {
        guard let index = getIndex(id) else { return }
        
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
    
    public func forTomorrow(by id: String) {
        guard let index = getIndex(id) else { return }
        
        // необходимо установить завтрашний день, а время оставить из даты
        let item = list[index]
        let date = item.date
        
        var cuttertdate = Date() // Текущая дата
        let calendar = Calendar.current
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: cuttertdate) {
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: tomorrow)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: date)
            dateComponents.hour = timeComponents.hour
            dateComponents.minute = timeComponents.minute
            dateComponents.second = 0
            if let updatedDate = calendar.date(from: dateComponents) {
                updateList(item.copy(date: updatedDate, isCompleted: false))
            }
        }
    }
    
    private func getIndex(_ id: String) -> Int? {
        guard !id.isEmpty, let index = list.firstIndex(where: { $0.id == id }) else { return nil }
        
        return index
    }
    
    // MARK: - Load
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
    
    private func updateList(_ newItem: ToDoItem) {
        var newList = list.filter { $0.id != newItem.id }
        newList.append(newItem)
        sortList(newList)
    }
    
    private func sortList(_ newList: [ToDoItem]) {
        guard isAuthorized() else { return }
        
        self.list = newList.sorted(by: <)
    }
    
    // MARK: - Show
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
            .sink(receiveValue: updateList)
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    public func edit(_ item: ToDoItem? = nil) {
        guard isAuthorized() else { return }
        isEdit = true
        
        router.navigate(to: .edit(item: item))
    }
    
    private func toLogin() {
        print("HomeViewModel: \(#function)")
        router.navigate(to: .login)
    }
    
    public func toProfile() {
        print("HomeViewModel: \(#function)")
        router.navigate(to: .profile)
    }
    
}
