//
//  HomeScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(\.homeViewModel) var viewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            
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
        .navigationTitle("To Do List")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel?.edit()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
}

#Preview {
    HomeScreen()
        .environment(\.homeViewModel, nil)
}
