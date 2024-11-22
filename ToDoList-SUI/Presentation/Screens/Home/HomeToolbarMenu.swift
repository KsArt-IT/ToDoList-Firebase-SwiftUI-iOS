//
//  ToolbarMenu.swift
//  ToDoList-SUI
//
//  Created by KsArT on 22.11.2024.
//

import SwiftUI

struct HomeToolbarMenu: View {
    @Binding var theme: AppTheme
    let toProfile: ()->Void
    let logout: ()->Void
    
    var body: some View {
        Menu {
            Section("Profile") {
                Button {
                    toProfile()
                } label: {
                    Label("Profile", systemImage: "person.circle")
                }
                Button {
                    logout()
                } label: {
                    Label("Logout", systemImage: "arrow.right.circle")
                }
            }
            Section("Theme:") {
                Button {
                    theme = .device
                } label: {
                    Label(
                        "Device",
                        systemImage: theme == .device ? "checkmark.circle" : "circle"
                    )
                }
                Button {
                    theme = .light
                } label: {
                    Label(
                        "Light",
                        systemImage: theme == .light ? "checkmark.circle" : "circle"
                    )
                }
                Button {
                    theme = .dark
                } label: {
                    Label(
                        "Dark",
                        systemImage: theme == .dark ? "checkmark.circle" : "circle"
                    )
                }
            }
        } label: {
            Label("Options", systemImage: "ellipsis.circle")
        }
    }
}
