//
//  HomeScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(\.router) var router
    @Environment(\.homeViewModelValue) var viewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.backgroundFirst, .backgroundSecond],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            if let list = viewModel?.list {
                LazyVStack {
                    ForEach(list) { item in
                        ItemView(item: item)
                    }
                }
            } else {
                Text("Empty")
            }
        }
    }
    
}

#Preview {
    HomeScreen()
        .environment(\.homeViewModelValue, nil)
}
