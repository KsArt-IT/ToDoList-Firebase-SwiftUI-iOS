//
//  HomeViewModelKey.swift
//  ToDoList-SUI
//
//  Created by KsArT on 16.10.2024.
//

import SwiftUI

private struct EditViewModelKey: EnvironmentKey {
    static let defaultValue: EditViewModel? = nil
}

extension EnvironmentValues {
    var editViewModel: EditViewModel? {
        get { self[EditViewModelKey.self] }
        set { self[EditViewModelKey.self] = newValue }
    }
}
