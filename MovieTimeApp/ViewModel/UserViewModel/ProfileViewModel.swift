//
//  ProfileViewModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 16.01.2024.
//

import Foundation

struct ProfileViewModel {
    var user: UserModel
    init(user: UserModel) {
        self.user = user
    }
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    var name: String? {
        return user.name
    }
    var username: String? {
        return user.username
    }
    var email: String? {
        return user.email
    }
}

