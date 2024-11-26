//
//  SplashScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isLogoVisible = false
    private let time = 2.0
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Image(.logoApp)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .opacity(isLogoVisible ? 1.0 : 0.0)
                    .scaleEffect(isLogoVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: time), value: isLogoVisible)
                Text(Constants.appName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.green)
                    .opacity(isLogoVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: time).delay(0.5), value: isLogoVisible)
            }
            Spacer()
            Text("KsArT.pro")
                .font(.caption)
        }
        .interactiveDismissDisabled()
        .toolbar(.hidden)
        .frame(maxWidth: .infinity)
        .background {
            BackgroundView()
        }
        .onAppear {
            withAnimation {
                self.isLogoVisible = true
            }
        }
    }
}

#Preview {
    SplashScreen()
}
