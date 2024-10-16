//
//  HomeViewModelKey.swift
//  ToDoList-SUI
//
//  Created by KsArT on 14.10.2024.
//

import SwiftUI

private struct RouterKey: EnvironmentKey {
    static let defaultValue: Router? = nil
}

extension EnvironmentValues {
    var router: Router? {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
