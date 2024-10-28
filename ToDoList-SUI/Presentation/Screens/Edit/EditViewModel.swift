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
    
    // отображение тостов и алертов
    var toastMessage = ""
    var alertMessage: AlertModifier.AlertType = ("", false)

    init(router: Router, repository: DataRepository) {
        print("EditViewModel: \(#function)")
        self.router = router
        self.repository = repository
    }
    
    public func save() {
        print("EditViewModel: \(#function)")
        guard !title.isEmpty else {
            showToast(String(localized: "Enter the task name!"))
            return
        }
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
                self?.close()
            case .failure(let error):
                self?.showError(error)
            case .none:
                break
            }
        }
    }
    
    public func editItem(_ item: ToDoItem?) {
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
    
    // MARK: - Nagigation
    
    func close() {
        print("EditViewModel: \(#function)")
        router.back()
    }
}
