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
    var isInitialized: Bool
    
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
    var isLoginDisabled: Bool {
        !(isCanClick && checkLogin() && checkPassword())
    }
    @ObservationIgnored private var isCanClick = true
    
    var clientID = ""
    var isSignInGoogle: Bool {
        !clientID.isEmpty
    }
    
    var isClose = false
    var showToast = ""
    var showAlert = ""
    
    var emailError = ""
    var passwordError = ""
    
    init(
        router: Router,
        repository: AuthRepository,
        validation: Validation,
        initialized: Bool
    ) {
        self.router = router
        self.repository = repository
        self.validation = validation
        self.isInitialized = initialized
        
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
        print("LoginViewModel: \(#function)")
        // сначала проверим необходим ли релогин
        if Profile.isInitialized && Profile.isRelogin {
            logout()
        } else {
            Task { [weak self] in
                if !Profile.isInitialized {
                    sleep(2)
                }
                await self?.fetchAuthUser()
            }
        }
    }
    
    private func fetchAuthUser() async {
        let result = await repository.fetchAuthUser()
        switch result {
        case .success(let user):
            print("LoginViewModel: \(#function) on")
            Profile.login(user: user)
            toHome()
        case .failure(let error):
            isInitialized = true
            guard Profile.isInitialized else { break }
            Profile.logout()
            showError(error)
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
                self?.showError(error)
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
                await self.showToastAuth()
                await self.fetchAuthUser()
            case .failure(let error):
                isCanClick = true
                self.showError(error)
            }
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
                self?.showError(error)
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
                await self?.showToastAuth()
                await self?.fetchAuthUser()
            case .failure(let error):
                self?.showError(error)
            case .none:
                break
            }
        }
    }
    
    public func onCloseSignInGoogle() {
        print("LoginViewModel: \(#function)")
        clientID = ""
    }
    
    private func showError(_ error: Error) {
        guard let error = error as? NetworkServiceError else { return }
        print("LoginViewModel: \(#function), Error: \(error.localizedDescription)")
        switch error {
        case .invalidRequest, .invalidResponse, .invalidDatabase,
                .statusCode(_, _), .decodingError(_), .networkError(_),
                .invalidCredential, .userNotFound, .userDisabled:
            showAlert = error.localizedDescription
        case .invalidEmail, .emailAlreadyInUse:
            emailError = error.localizedDescription
        case .wrongPassword, .weakPassword:
            passwordError = error.localizedDescription
        case .cancelled:
            break
        }
    }
    
    private func showToastAuth() async {
        showToast = String(localized: "Successful authorization")
        sleep(4)
    }
    
    // MARK: - Navigation
    public func toResetPassword() {
        router.navigate(to: .resetPassword)
    }
    
    private func toHome() {
        //        guard !isCanClick else { return }
        isClose = true
        Profile.initialize()
        router.navigateToRoot()
    }
    
    public func toRegistration() {
        router.navigate(to: .registration)
    }
    
}
