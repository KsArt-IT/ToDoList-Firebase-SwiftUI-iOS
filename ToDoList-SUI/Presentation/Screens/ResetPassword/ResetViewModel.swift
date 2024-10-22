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
    
    var email: String = ""
    var isButtonDisabled: Bool {
        !(isCanClick && checkEmail())
    }
    @ObservationIgnored var isCanClick = true
    var viewError = ViewError.none

    var time = "" // задержка перед следующей отправкой
    @ObservationIgnored private var timer: Timer?
    @ObservationIgnored private var counter = 0
    @ObservationIgnored private let counterStart = 30
    
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
                // успешная регистрация, перейти на экран логина
                self.onLogin()
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
        self.viewError = switch error {
        case .invalidRequest, .invalidResponse, .invalidDatabase,
                .statusCode(_, _), .decodingError(_), .networkError(_),
                .invalidCredential, .userNotFound, .userDisabled:
                .alert(message: error.localizedDescription)
        case .invalidEmail, .emailAlreadyInUse:
                .email(message: error.localizedDescription)
        case .wrongPassword, .weakPassword:
                .password(message: error.localizedDescription)
        case .cancelled:
                .none
        }
    }
    
    // MARK: - Navigation
    public func onLogin() {
        router.back()
    }
}
