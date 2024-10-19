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
            LoginScreen(viewModel: DIManager.shared.resolve())
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        HomeScreen(viewModel: homeViewModel)
                    case .edit(let id):
                        EditScreen(id, viewModel: DIManager.shared.resolve())
                    case .splash:
                        SplashScreen()
                            .onAppear {
                                Task {
                                    sleep(2)
                                    router.navigateToRoot()
                                }
                            }
                    case .registration:
                        EmptyView()
                    case .resetPassword:
                        EmptyView()
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
