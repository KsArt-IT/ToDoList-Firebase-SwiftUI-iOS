//
//  ProfileViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 29.10.2024.
//

import Foundation

@Observable
final class ProfileViewModel {
    @ObservationIgnored private let router: Router
    @ObservationIgnored private let repository: UserRepository

    var profile: UserData?
    
    // отображение тостов и алертов
    var toastMessage = ""
    var alertMessage: AlertModifier.AlertType = ("", false)

    init(router: Router, repository: UserRepository) {
        print("ProfileViewModel: \(#function)")
        self.router = router
        self.repository = repository
        
        loadUser()
    }
    
    private func loadUser() {
        Task {
            let result = await repository.loadUser()
            switch result {
            case .success(let user):
                profile = user
            case .failure(let error):
                showError(error)
            }
        }
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
    
    // MARK: - Navigation
    public func toEdit() {
        router.navigate(to: .profileEdit(profile))
    }
    
    private func toHome() {
        router.back()
    }

}
