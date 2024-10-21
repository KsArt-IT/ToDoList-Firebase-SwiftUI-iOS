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
    
    var login: String = ""
    var password: String = ""
    var passwordConfirm: String = ""
    var isLoginDisabled: Bool {
        !(isCanClick && checkLogin() && checkPassword())
    }
    @ObservationIgnored var isCanClick = true
    var viewError = ViewError.none
    
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
                self.onLogin()
            case .failure(let error):
                self.showError(error)
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
