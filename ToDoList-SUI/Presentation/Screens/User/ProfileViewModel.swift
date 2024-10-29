//
//  ProfileViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 29.10.2024.
//

import Foundation

@Observable
final class ProfileViewModel {
    @ObservationIgnored private let router: Router
    @ObservationIgnored private let repository: DataRepository

    var profile: UserData?
    
    init(router: Router, repository: DataRepository) {
        print("ProfileViewModel: \(#function)")
        self.router = router
        self.repository = repository
    }
}
