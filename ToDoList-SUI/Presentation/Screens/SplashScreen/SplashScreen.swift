//
//  SplashScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct SplashScreen: View {
    
    var body: some View {
        VStack {
            Spacer()
            Image(.logoApp)
                .resizable()
                .frame(width: 250, height: 250)
            Spacer()
            Text("KsArT.pro")
        }
    }
}

#Preview {
    SplashScreen()
}
