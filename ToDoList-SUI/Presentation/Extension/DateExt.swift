//
//  DateExt.swift
//  ToDoList-SUI
//
//  Created by KsArT on 15.10.2024.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.YYYY HH:mm"
    return formatter
}()

extension Date {
    func toStringDateTime() -> String {
        dateFormatter.string(from: self)
    }
}