//
//  HomeScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct HomeScreen: View {
    @State private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if viewModel.list.isEmpty {
                NoItemView {
                    viewModel.edit()
                }
            } else {
                List(viewModel.listSearch) { item in
                    ItemView(item: item, toggle: viewModel.toggleCompleted, action: viewModel.edit)
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.delete(by: item.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.forTomorrow(by: item.id)
                            } label: {
                                Label("For tomorrow", systemImage: "arrow.turn.up.right")
                            }
                            .tint(.blue)
                        }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.reloadData()
                }
                
                ProgressView("Completed", value: viewModel.progressCompleted)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
            }
        }
        // MARK: - Navigation
        .navigationTitle("To Do List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.edit()
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
            ToolbarItemGroup(placement: .secondaryAction) {
                Button {
                    viewModel.toProfile()
                } label: {
                    Label("Profile", systemImage: "person.circle")
                }
                Button {
                    viewModel.logout()
                } label: {
                    Label("Logout", systemImage: "arrow.right.circle")
                }
            }
        }
        // MARK: - Search by category
        .searchable(
            text: $viewModel.searchText,
            tokens: $viewModel.selectedTokens,
            suggestedTokens: $viewModel.suggestedTokens
        ) { token in
            Label(token.rawValue, systemImage: token.systemImage)
                .font(.title2)
        }
        // MARK: - Toast, Alert
        .showToast($viewModel.toastMessage)
        .showAlert($viewModel.alertMessage)
        // MARK: - Background
        .background {
            BackgroundView()
        }
        .onAppear {
            viewModel.onShowView()
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
    
}

#Preview {
    //    HomeScreen(viewModel: HomeViewModel(router: RouterApp(), repository: DataRepositoryPreview()))
}
