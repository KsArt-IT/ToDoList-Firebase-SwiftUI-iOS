//
//  DIManager.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Foundation
import Swinject

class DIManager {
    static let shared = DIManager()
    private let container: Container = Container()
    
    private init() {
        registerRouter()
        
        registerReposiroty()
        registerReposirotyAuth()
        
        registerHomeViewModel()
        registerEditViewModel()
        
        registerValidation()
        registerLoginViewModel()
        registerRegistrationViewModel()
    }
    
    //MARK: - Регистрация зависимостей
    private func registerRouter() {
        print(#function)
        container.register(Router.self) { _ in RouterApp(.splash) }
            .inObjectScope(.weak)
    }
    
    private func registerReposiroty() {
        container.register(DataService.self) { _ in LocalDataServiceImpl() }
        container.register(DataRepository.self) { r in
            LocalDataRopositoryImpl(service: r.resolve(DataService.self)!)
        }
        .inObjectScope(.container)
    }
    
    private func registerReposirotyAuth() {
        container.register(AuthService.self) { _ in FirebaseAuthServiceImpl() }
        container.register(AuthRepository.self) { r in
            FirebaseAuthRepositoryImpl(service: r.resolve(AuthService.self)!)
        }
        .inObjectScope(.weak)
    }
    
    private func registerHomeViewModel() {
        print(#function)
        container.register(HomeViewModel.self) { r in
            HomeViewModel(
                router: r.resolve(Router.self)!,
                repository: r.resolve(DataRepository.self)!
            )
        }
        .inObjectScope(.weak)
    }
    
    private func registerEditViewModel() {
        print(#function)
        container.register(EditViewModel.self) { r in
            EditViewModel(
                router: r.resolve(Router.self)!,
                repository: r.resolve(DataRepository.self)!
            )
        }
    }
    
    private func registerValidation() {
        print(#function)
        container.register(Validation.self) { _ in
            Validation()
        }
    }
    
    private func registerLoginViewModel() {
        print(#function)
        container.register(LoginViewModel.self) { r in
            LoginViewModel(
                router: r.resolve(Router.self)!,
                repository: r.resolve(AuthRepository.self)!,
                validation: r.resolve(Validation.self)!
            )
        }
    }
    
    private func registerRegistrationViewModel() {
        print(#function)
        container.register(RegistrationViewModel.self) { r in
            RegistrationViewModel(
                router: r.resolve(Router.self)!,
                repository: r.resolve(AuthRepository.self)!,
                validation: r.resolve(Validation.self)!
            )
        }
    }
    
    // MARK: - Получение зависимостей
    func resolve<T>(_ type: T.Type) -> T? {
        print("\(#function): \(type)")
        return container.resolve(type)
    }
    
    func resolve<T>() -> T {
        resolve(T.self)!
    }
    
}
