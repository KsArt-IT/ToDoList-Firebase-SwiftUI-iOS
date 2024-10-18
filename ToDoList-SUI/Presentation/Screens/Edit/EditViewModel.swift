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
    
    @ObservationIgnored private var item = ToDoItem(
        id: "",
        date: Date(),
        title: "",
        text: "",
        isCritical: false,
        isCompleted: false
    )
    var newTask = true
    var title = ""
    var text = ""
    var date = Date()
    var time = Date()
    var isCritical = false
    var isSaveDisabled: Bool {
        title.isEmpty
    }
    
    init(router: Router, repository: DataRepository) {
        print("EditViewModel: \(#function)")
        self.router = router
        self.repository = repository
    }
    
    public func save() {
        print("EditViewModel: \(#function)")
        let item = item.copy(
            date: combineDateWithTime(),
            title: title,
            text: text,
            isCritical: isCritical,
            isCompleted: false
        )
        Task { [weak self] in
            let result = await self?.repository.saveData(item)
            switch result {
            case .success(_):
                self?.toBack()
            case .failure(let error):
                print("Error: \(error)")
            case .none:
                break
            }
        }
    }
    
    public func loadItem(_ id: String) {
        guard !id.isEmpty else { return }
        
        Task { [weak self] in
            let result = await self?.repository.fetchData(id)
            switch result {
            case .success(let item):
                self?.setParams(item)
            case .failure(let error):
                print("Error: \(error)")
            case .none:
                break
            }
        }
    }
    
    private func setParams(_ item: ToDoItem?) {
        guard let item else { return }
        self.item = item
        self.newTask = false
        self.title = item.title
        self.text = item.text
        self.date = item.date
        self.time = item.date
        self.isCritical = item.isCritical
    }
    
    // Объединяет дату и время в одну дату
    private func combineDateWithTime(date: Date? = nil, time: Date? = nil) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date ?? self.date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time ?? self.date)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        dateComponents.second = 0

        let dateTime = calendar.date(from: dateComponents) ?? date ?? time ?? Date()
        return dateTime
    }
    
    // MARK: - Nagigation
    
    func toBack() {
        router.back()
    }
}
