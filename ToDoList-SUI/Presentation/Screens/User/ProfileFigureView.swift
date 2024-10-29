//
//  FigureView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 29.10.2024.
//

import SwiftUI

struct ProfileFigureView: View {
    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat = geometry.size.width
            let height: CGFloat = geometry.size.height
            
            Path { path in
                path.move(
                    to: CGPoint(
                        x: 0,
                        y: height * 0.20
                    )
                )
                path.addLine(
                    to: CGPoint(
                        x: width * 0.30,
                        y: height * 0.65
                    )
                )
                path.addLine(
                    to: CGPoint(
                        x: 0,
                        y: height
                    )
                )
            }
            .fill(Color.backgroundSecond)
            Path { path in
                path.move(
                    to: CGPoint(
                        x: 0,
                        y: height
                    )
                )
                path.addLine(
                    to: CGPoint(
                        x: width * 0.30,
                        y: height * 0.65
                    )
                )
                path.addLine(
                    to: CGPoint(
                        x: width,
                        y: height * 0.70
                    )
                )
                path.addLine(
                    to: CGPoint(
                        x: width,
                        y: height
                    )
                )
            }
            .fill(Color.backgroundFirst)
        }
    }
}

#Preview {
    ProfileFigureView()
}
