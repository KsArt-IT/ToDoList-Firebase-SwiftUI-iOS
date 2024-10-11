//
//  DIManager.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Swinject

class DIManager {
    static let shared = DIManager()
    let container: Container

    private init() {
        container = Container()
    }

    // Регистрация зависимостей
    private func registerReposiroty() {
        guard container.resolve(DataRepository.self) == nil else { return }
        
        container.register(DataService.self) { _ in LocalDataServiceImpl() }
        container.register(DataRepository.self) { r in LocalDataRopositoryImpl(service: r.resolve(DataService.self)!) }
    }
    
    func registerHomeViewModel() {
        if container.resolve(DataRepository.self) == nil {
            registerReposiroty()
        }
        
        container.register(HomeViewModel.self) { r in HomeViewModel(repository: r.resolve(DataRepository.self)!) }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
    
    
}
