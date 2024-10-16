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
        registerHomeViewModel()
        registerEditViewModel()
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
    
    private func registerHomeViewModel() {
        print(#function)
        // Регестрируем Optional
        container.register(HomeViewModel?.self) { r in
            HomeViewModel(
                router: r.resolve(Router.self)!,
                repository: r.resolve(DataRepository.self)!
            )
        }
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
    
    // MARK: - Получение зависимостей
    func resolve<T>(_ type: T.Type) -> T? {
        print("\(#function): \(type)")
        return container.resolve(type)
    }
    
    func resolve<T>() -> T {
        resolve(T.self)!
    }
    
}
