//
//  LoginLogoView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 02.11.2024.
//

import SwiftUI

struct LoginLogoView: View {
    var body: some View {
        Image("loginLogo")
            .resizable()
            .layoutPriority(-1)
            .scaledToFit()
            .frame(maxWidth: 100, maxHeight: 100)
    }
}

#Preview {
    LoginLogoView()
}
