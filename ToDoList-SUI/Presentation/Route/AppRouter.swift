//
//  Router.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

@Observable
final class AppRouter: AnyObject {
    var navigationPath = NavigationPath()
    
    init(_ start: Route? = nil) {
        guard let start else { return }
        
        navigate(to: start)
    }
    
    /// Переход на конкретный экран
    func navigate(to route: Route) {
        navigationPath.append(route)
    }
    
    /// Вернуться на корневой экран
    func navigateToRoot() {
        guard !navigationPath.isEmpty else { return }
        
        navigationPath.removeLast(navigationPath.count)
    }

    /// Вернуться назад
    func back() {
        guard !navigationPath.isEmpty else { return }
        
        navigationPath.removeLast()
    }
    
}
