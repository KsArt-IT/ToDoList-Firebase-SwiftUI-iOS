//
//  Router.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

@Observable
final class RouterApp: Router {
    var navigationPath = NavigationPath()
    
    init(_ start: Route? = nil) {
        guard let start else { return }
        
        navigate(to: start)
    }
    
    /// Переход на конкретный экран
    func navigate(to route: Route) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationPath.append(route)
            
            print("route: \(route) count=\(String(describing: self?.navigationPath.count)) main=\(String(describing: Thread.isMainThread))")
        }
    }
    
    /// Вернуться на корневой экран
    func navigateToRoot() {
        guard !navigationPath.isEmpty else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.navigationPath.removeLast(self.navigationPath.count)
        }
    }
    
    /// Вернуться назад
    func back() {
        guard !navigationPath.isEmpty else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.navigationPath.removeLast()
        }
    }
    
}

protocol Router: AnyObject {
    var navigationPath: NavigationPath { get set }
    func navigate(to route: Route)
    func navigateToRoot()
    func back()
}
