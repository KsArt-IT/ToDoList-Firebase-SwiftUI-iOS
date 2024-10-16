//
//  BackgroundView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 16.10.2024.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [.backgroundFirst, .backgroundSecond],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
