//
//  LoginViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 18.10.2024.
//

import Foundation

@Observable
final class LoginViewModel {
    
    @ObservationIgnored private let router: Router
    @ObservationIgnored private let repository: AuthRepository
    @ObservationIgnored private let validation: Validation
    
    var isSignInGoogle: Bool {
        !clientID.isEmpty
    }
    var clientID = ""
    var login: String = ""
    var password: String = ""
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
        
        // проверить авторизацию
        self.checkAuthorization()
    }
    
    private func checkLogin() -> Bool {
        validation.isEmail(login)
    }
    
    private func checkPassword() -> Bool {
        validation.isPassword(password)
    }
    
    private func checkAuthorization() {
        // сначала проверим необходим ли релогин
        if Profile.isRelogin {
            logout()
        } else {
            // проверить авторизацию
            setAuthUser()
        }
    }
    
    private func logout() {
        Task { [weak self] in
            Profile.logout()
            let result = await self?.repository.logout()
            // проверить на ошибки сети
            switch result {
            case .success(_):
                break
            case .failure(let error):
                guard let networkError = error as? NetworkServiceError else { break }
                switch networkError {
                case .cancelled:
                    break
                default:
                    // ошибки сети необходимо вывести алерт
                    print(networkError.localizedDescription)
                }
            case .none:
                break
            }
        }
    }
    
    private func setAuthUser() {
        print("LoginViewModel: \(#function)")

        Task { [weak self] in
            let result = await self?.repository.fetchAuthUser()
            switch result {
            case .success(let user):
                Profile.login(user: user)
                self?.toHome()
            case .failure(let error):
                Profile.logout()
                self?.showError(error: error)
            case .none:
                break
            }
        }
    }
    
    public func signIn() {
        guard !isLoginDisabled else { return }
        print("LoginViewModel: \(#function)")

        isCanClick = false
        Task { [weak self] in
            guard let self else { return }
            
            let result = await self.repository.signIn(email: self.login, password: self.password)
            switch result {
            case .success(_):
                // успешная авторизация, получить пользователя и перейти на основной экран
                self.setAuthUser()
            case .failure(let error):
                self.showError(error: error)
            }
            isCanClick = true
        }
    }
    
    public func signInGoogle() {
        guard !isSignInGoogle else { return }
        print("LoginViewModel: \(#function)")

        Task { [weak self] in
            let result = await self?.repository.signInGoogle()
            switch result {
            case .success(let clientID):
                self?.clientID = clientID
            case .failure(let error):
                self?.onCloseSignInGoogle()
                self?.showError(error: error)
            case .none:
                break
            }
        }
    }
    
    public func submitSignInGoogle(idToken: String, accessToken: String) {
        Task { [weak self] in
            let result = await self?.repository.signIn(withIDToken: idToken, accessToken: accessToken)
            self?.onCloseSignInGoogle()
            switch result {
            case .success(_):
                // успешная авторизация, получить пользователя и перейти на основной экран
                self?.setAuthUser()
            case .failure(let error):
                self?.showError(error: error)
            case .none:
                break
            }
        }
    }
    
    public func onCloseSignInGoogle() {
        print("LoginViewModel: \(#function)")
        clientID = ""
    }
    
    private func showError(error: Error) {
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
    public func toResetPassword() {
        router.navigate(to: .resetPassword)
    }
    
    private func toHome() {
//        guard !isCanClick else { return }
        router.navigateToRoot()
    }
    
    public func toRegistration() {
        router.navigate(to: .registration)
    }
    
}
