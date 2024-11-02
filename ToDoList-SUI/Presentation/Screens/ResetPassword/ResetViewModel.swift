//
//  ResetViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 22.10.2024.
//

import Foundation

@Observable
final class ResetViewModel {
    
    @ObservationIgnored private let router: Router
    @ObservationIgnored private let repository: AuthRepository
    @ObservationIgnored private let validation: Validation
    
    var email: String = "" {
        didSet {
            emailError = ""
        }
    }
    var emailError = ""

    @ObservationIgnored private var isCanClick = true
    var isButtonDisabled: Bool {
        !(isCanClick && checkEmail())
    }
    // отображение тостов и алертов
    var toastMessage = ""
    var alertMessage: AlertModifier.AlertType = ("", false)
    
    // не отправлять запросы на восстановление чаще
    @ObservationIgnored private let counterStart = 30
    @ObservationIgnored private var counter = 0
    @ObservationIgnored private var timer: Timer?
    var time = ""

    init(
        router: Router,
        repository: AuthRepository,
        validation: Validation
    ) {
        self.router = router
        self.repository = repository
        self.validation = validation
    }
    
    private func checkEmail() -> Bool {
        validation.isEmail(email)
    }
    
    public func resetPassword() {
        guard !isButtonDisabled else { return }
        setPause()
        Task { [weak self] in
            guard let self else { return }
            
            let result = await self.repository.resetPassword(email: self.email)
            switch result {
            case .success(_):
                // показать алерт и перейти на логин
                self.showAlert(String(localized: "password recovery"))
            case .failure(let error):
                self.showError(error)
            }
        }
    }
    
    private func setPause() {
        guard isCanClick else { return }
        isCanClick = false
        counter = counterStart
        time = counter.description
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            self.counter -= 1
            if self.counter < 0 {
                self.time = ""
                self.isCanClick = true
                timer?.invalidate()
            } else {
                self.time = counter.description
            }
        }
    }
    
    private func showError(_ error: Error) {
        guard let error = error as? NetworkServiceError else { return }
        print("LoginViewModel: \(#function), Error: \(error.localizedDescription)")
        switch error {
        case .invalidRequest, .invalidResponse, .invalidDatabase,
                .statusCode(_, _), .decodingError(_), .networkError(_),
                .invalidCredential, .userNotFound, .userDisabled:
            showAlert(error.localizedDescription, isError: true)
        case .invalidEmail, .emailAlreadyInUse:
            emailError = error.localizedDescription
        case .wrongPassword, .weakPassword:
            break
        case .cancelled, .profileNotInitialized:
            break
        }
    }
    
    private func showAlert(_ message: String, isError: Bool = false) {
        alertMessage = (message, isError)
    }
    
    public func actionAlert() {
        // если это не ошибка была показана, то перейти на логин
        if !alertMessage.isError {
            close()
        }
    }
    
    // MARK: - Navigation
    public func close() {
        router.back()
    }
}
