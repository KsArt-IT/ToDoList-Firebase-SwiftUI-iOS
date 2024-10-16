//
//  ContentView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var router: Router = DIManager.shared.resolve()
    @State private var homeViewModel: HomeViewModel?
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            HomeScreen()
                .environment(\.homeViewModel, homeViewModel)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        EmptyView()
                            .onAppear {
                                router.navigateToRoot()
                            }
                    case .edit(let id):
                        EditScreen(id)
                            .environment(\.editViewModel, DIManager.shared.resolve())
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
            homeViewModel = DIManager.shared.resolve()
            sleep(1)
            router.navigateToRoot()
        }
    }
}

#Preview {
    ContentView()
}
