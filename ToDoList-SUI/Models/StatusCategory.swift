//
//  StatusCategory.swift
//  ToDoList-SUI
//
//  Created by KsArT on 01.11.2024.
//

import SwiftUICore

public enum StatusCategory: LocalizedStringKey, CaseIterable, Hashable, Identifiable {
    case active = "Active"
    case critical = "Critical"
    case completed = "Completed"
    case expired = "Expired"
    
    public var id: Self { self }
}

extension StatusCategory {
    func checkStatus(_ item: ToDoItem) -> Bool {
        switch self {
        case .active:
            item.timeMin != nil && item.timeMin! > -Constants.timeInterval
        case .critical:
            item.timeMin != nil && -Constants.timeInterval...Constants.timeInterval ~= item.timeMin!
        case .completed:
            item.timeMin == nil
        case .expired:
            item.timeMin != nil && item.timeMin! == Int.min
        }
    }
    
    var systemImage: String {
        switch self {
        case .active:
            "pencil.and.list.clipboard"
        case .critical:
            "person.badge.clock"
        case .completed:
            "checkmark.seal"
        case .expired:
            "trash"
        }
    }
}
