//
//  ContentView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var router: Router = DIManager.shared.resolve()
    @State private var homeViewModel: HomeViewModel = DIManager.shared.resolve()
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            HomeScreen(viewModel: homeViewModel)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .edit(let id):
                        EditScreen(id, viewModel: DIManager.shared.resolve())
                    case .login:
                        LoginScreen(viewModel: DIManager.shared.resolve())
                    case .registration:
                        RegistrationScreen(viewModel: DIManager.shared.resolve())
                    case .resetPassword:
                        ResetScreen(viewModel: DIManager.shared.resolve())
                    }
                }
                .onAppear {
                    print("router: \(router.navigationPath.count)")
                }
        }
    }
}

#Preview {
    ContentView()
}
