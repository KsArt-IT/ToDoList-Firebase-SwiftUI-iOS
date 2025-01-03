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
    
    @ObservationIgnored private var timerUpdate: Timer?
    var list: [ToDoItem] = [] {
        didSet {
            changeStatistics(.active, change: true)
        }
    }
    var listSearch: [ToDoItem] {
        if list.isEmpty || searchText.isEmpty && selectedTokens.isEmpty {
            list
        } else {
            list.filter { item in
                (searchText.isEmpty || item.title.localizedCaseInsensitiveContains(searchText)) &&
                (selectedTokens.isEmpty || selectedTokens.contains(where: { $0.checkStatus(item)}))
            }
        }
    }
    
    var searchText: String = ""
    var selectedTokens: [StatusCategory] = []
    var suggestedTokens: [StatusCategory] = StatusCategory.allCases
    
    // отображение прогресса выполненных задач
    var progressCompleted: Double {
        list.count > 0 ? Double(list.count(where: { $0.isCompleted })) / Double(list.count) : 0
    }
    @ObservationIgnored private var isEdit = false
    // отображение тостов и алертов
    var toastMessage = ""
    var alertMessage: AlertModifier.AlertType = ("", false)
    
    @ObservationIgnored private var profile: UserData? {
        didSet {
            saveProfile()
        }
    }
    
    init(router: Router, repository: DataRepository, userRepository: UserRepository) {
        print("HomeViewModel: \(#function)")
        self.router = router
        self.repository = repository
        self.userRepository = userRepository
        
        // наблюдаем за добавлением и изменением записей
        self.subscribeUpdate()
    }
    
    private func subscribeUpdate() {
        repository.updatePublisher
            .sink(receiveValue: updateList)
            .store(in: &cancellables)
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
    
    // MARK: - Profile change task statistics
    private func changeStatistics(_ stat: Statistics, change: Bool) {
        switch stat {
        case .created:
            if change {
                // это новый, добавить
                profile?.taskCreated += 1
            }
        case .active:
            profile?.taskActive = list.count(where: { $0.isActive() })
        case .deleted:
            profile?.taskDeleted += 1
        case .completed:
            if change {
                profile?.taskCompleted += 1
            } else {
                profile?.taskCompleted -= 1
            }
        }
    }
    
    // MARK: - Operations
    public func toggleCompleted(_ id: String) {
        guard let item = list.first(where: { $0.id == id }) else { return }
        
        Task { [weak self] in
            let result = await self?.repository.saveData(item.copy(isCompleted: !item.isCompleted))
            switch result {
            case .success(_):
                self?.changeStatistics(.completed, change: !item.isCompleted)
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
                self?.changeStatistics(.deleted, change: true)
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
        
        let calendar = Calendar.current
        // добавим день к текущей дате
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) {
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
        list.firstIndex(where: { $0.id == id })
    }
    
    // MARK: - Load
    public func reloadData() async {
        // вызывать каждый раз
        await fetchData()
    }
    
    public func loadData() {
        // не чаще раз в x сек
        guard timeLoadData == nil || Date().timeIntervalSince(timeLoadData!) > timeDelay else { return }
        
        guard isAuthorized() else { return }
        print("HomeViewModel: \(#function)")
        
        if taskLoadData != nil {
            taskLoadData?.cancel()
        }
        taskLoadData = Task { [weak self] in
            await self?.fetchData()
        }
    }
    
    private func fetchData() async {
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
    
    // MARK: - Update
    private func updateList(_ newItem: ToDoItem) {
        var newList = list.filter { $0.id != newItem.id }
        changeStatistics(.created, change: list.count == newList.count)
        newList.append(newItem)
        sortList(newList)
    }
    
    private func sortList(_ newList: [ToDoItem]) {
        guard isAuthorized() else { return }
        
        Task { [weak self] in
            let listSorted = newList.sorted(by: <)
            if self?.list != listSorted {
                print("HomeViewModel: \(#function) list sorted")
                self?.changeTime(listSorted)
            }
        }
    }
    
    private func changeTime(_ newList: [ToDoItem]?) {
        guard let newList else { return }
        guard !newList.isEmpty else {
            setList(newList)
            return
        }
        var changedList = newList
        var change = false
        
        let currentDate = Date()
        
        for index in 0..<newList.endIndex {
            let item = newList[index]
            var timeMin: Int?
            if item.isCompleted {
                timeMin = nil
            } else {
                let interval = Int(item.date.timeIntervalSince(currentDate) / 60) // минут
                timeMin = switch interval {
                case -Constants.timeInterval...Constants.timeInterval:
                    interval
                case let diff where diff < 0: // прошло время
                    Int.min
                default:
                    Int.max
                }
            }
            if item.timeMin != timeMin {
                changedList[index] = item.copy(timeMin: timeMin)
                change = true
            }
        }
        setList(changedList, force: change)
    }
    
    private func setList(_ list: [ToDoItem], force: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            if let self, force || self.list != list {
                self.list = list
                if self.timerUpdate == nil, !self.list.isEmpty {
                    self.startTimer()
                }
            }
        }
    }
    
    // MARK: - Timer
    public func startTimer() {
        guard self.timerUpdate == nil else { return }
        
        if !self.list.isEmpty && self.list.first(where: { $0.isActive() }) != nil {
            self.timerUpdate = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
                self?.changeTime(self?.list)
            }
        }
    }
    
    public func stopTimer() {
        if let timerUpdate {
            timerUpdate.invalidate()
        }
        timerUpdate = nil
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
