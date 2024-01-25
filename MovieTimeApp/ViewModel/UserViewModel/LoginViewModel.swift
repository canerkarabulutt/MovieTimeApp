//
//  LoginViewModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 16.01.2024.
//

import UIKit

struct LogInViewModel {
    var emailText: String?
    var passwordText: String?
    
    var status: Bool {
        return emailText?.isEmpty == false && passwordText?.isEmpty == false
    }
}

