//
//  StatusCategory.swift
//  ToDoList-SUI
//
//  Created by KsArT on 01.11.2024.
//

import SwiftUICore

public enum StatusCategory: LocalizedStringKey, CaseIterable, Hashable {
    case active = "Active"
    case critical = "Critical"
    case completed = "Completed"
    case expired = "Expired"
    
    func checkStatus(_ item: ToDoItem) -> Bool {
        switch self {
        case .active:
            item.timeMin != nil && item.timeMin! > -60
        case .critical:
            item.timeMin != nil && -60...60 ~= item.timeMin!
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

struct Category: Identifiable, Hashable {
    let id = UUID()
    let value: StatusCategory
}

