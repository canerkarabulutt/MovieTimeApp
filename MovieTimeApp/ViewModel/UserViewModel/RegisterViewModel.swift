//
//  RegisterViewModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 16.01.2024.
//

import UIKit

class RegisterViewModel {
    var emailText: String?
    var passwordText: String?
    var nameText: String?
    var usernameText: String?
    
    var status: Bool {
        return emailText?.isEmpty == false && passwordText?.isEmpty == false && nameText?.isEmpty == false && usernameText?.isEmpty == false
    }
}
