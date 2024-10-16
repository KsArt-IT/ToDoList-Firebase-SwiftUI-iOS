//
//  HomeViewModelKey.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import SwiftUI

private struct HomeViewModelKey: EnvironmentKey {
    static let defaultValue: HomeViewModel? = nil
}

extension EnvironmentValues {
    var homeViewModelValue: HomeViewModel? {
        get { self[HomeViewModelKey.self] }
        set { self[HomeViewModelKey.self] = newValue }
    }
}
