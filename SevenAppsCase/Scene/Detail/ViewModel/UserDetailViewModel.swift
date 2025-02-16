//
//  UserDetailViewModel.swift
//  SevenAppsCase
//
//  Created by Barış Dilekçi on 16.02.2025.
//

import Foundation

final class UserDetailViewModel {
    
    let userName: String
    let email: String
    let phone: String
    let website: String

    init(user: User) {
        self.userName = user.name
        self.email = user.email
        self.phone = user.phone
        self.website = user.website
    }
}
