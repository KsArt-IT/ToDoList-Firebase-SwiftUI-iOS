//
//  ContentView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var router: Router = DIManager.shared.resolve()
//    @State private var homeViewModel: HomeViewModel?
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            HomeScreen(viewModel: DIManager.shared.resolve())
//                .environment(\.homeViewModel, homeViewModel)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        EmptyView()
                            .onAppear {
                                router.navigateToRoot()
                            }
                    case .edit(let id):
                        EditScreen(id, viewModel: DIManager.shared.resolve())
                    case .splash:
                        SplashScreen()
                            .navigationBarBackButtonHidden(true)
                            .interactiveDismissDisabled()
                            .onAppear {
                                initDataAndGoHome()
                            }
                    }
                }
        }
    }
}

extension ContentView {
    private func initDataAndGoHome() {
        Task {
//            homeViewModel = DIManager.shared.resolve()
            // bнициализация
            _ = DIManager.shared.resolve(HomeViewModel.self)
            sleep(1)
            router.navigateToRoot()
        }
    }
}

#Preview {
    ContentView()
}
