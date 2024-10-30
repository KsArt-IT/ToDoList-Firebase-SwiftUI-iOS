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
                List(viewModel.list) { item in
                    ItemView(item: item, toggle: viewModel.toggleCompleted, action: viewModel.edit)
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.delete(by: item.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                }
                .listStyle(.plain)
                
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
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        // Действие для профиля
                        print("Profile tapped")
                        viewModel.toProfile()
                    } label: {
                        Label("Profile", systemImage: "person.circle")
                    }
                    Button {
                        viewModel.logout()
                    } label: {
                        Label("Logout", systemImage: "arrow.right.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
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
        }
    }
    
}

#Preview {
//    HomeScreen(viewModel: HomeViewModel(router: RouterApp(), repository: DataRepositoryPreview()))
}
