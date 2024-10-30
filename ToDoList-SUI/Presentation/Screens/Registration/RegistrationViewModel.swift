//
//  RegistrationViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 21.10.2024.
//

import Foundation

@Observable
final class RegistrationViewModel {
    
    @ObservationIgnored private let router: Router
    @ObservationIgnored private let repository: AuthRepository
    @ObservationIgnored private let validation: Validation
    
    var login: String = "" {
        didSet {
            emailError = ""
        }
    }
    var password: String = "" {
        didSet {
            passwordError = ""
        }
    }
    @ObservationIgnored private let confirmError = String(localized: "passwords do not match")
    var passwordConfirm: String = "" {
        didSet {
            if password.count == passwordConfirm.count && password != passwordConfirm {
                passwordConfirmError = confirmError
            } else {
                passwordConfirmError = ""
            }
        }
    }
    var isLoginDisabled: Bool {
        !(isCanClick && checkLogin() && checkPassword())
    }
    @ObservationIgnored var isCanClick = true

    // отображение тостов и алертов
    var toastMessage = ""
    var alertMessage: AlertModifier.AlertType = ("", false)

    // Отображение ошибок в полях ввода
    var emailError = ""
    var passwordError = ""
    var passwordConfirmError = ""
    
    init(
        router: Router,
        repository: AuthRepository,
        validation: Validation
    ) {
        self.router = router
        self.repository = repository
        self.validation = validation
    }
    
    private func checkLogin() -> Bool {
        validation.isEmail(login)
    }
    
    private func checkPassword() -> Bool {
        validation.isPassword(password) && passwordConfirm == password
    }
    
    public func register() {
        guard !isLoginDisabled else { return }
        isCanClick = false
        
        Task { [weak self] in
            guard let self else { return }
            
            let result = await self.repository.signUp(email: self.login, password: self.password)
            switch result {
            case .success(_):
                // успешная регистрация, перейти на экран логина
                await self.showToastAuth()
                self.onLogin()
            case .failure(let error):
                self.showError(error)
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
            passwordError = error.localizedDescription
        case .cancelled, .profileNotInitialized:
            break
        }
    }
    
    private func showToastAuth() async {
        showToast(String(localized: "Successful registration"))
        sleep(4)
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
    }
    
    private func showAlert(_ message: String, isError: Bool = false) {
        alertMessage = (message, isError)
    }
    
    // MARK: - Navigation
    public func onLogin() {
        router.back()
    }
}
