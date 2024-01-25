//
//  AuthService.swift
//  MovieApp
//
//  Created by Caner Karabulut on 16.01.2024.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

struct AuthRegisterModel {
    let emailText: String
    let passwordText: String
    let usernameText: String
    let nameText: String
    let profileImage: UIImage
}
struct AuthService {
    // Fetch User
    static func fetchUser(uid: String, completion: @escaping(UserModel) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            let user = UserModel(data: data)
            completion(user)
        }
    }
    // Login
    static func login(emailText: String, passwordText: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: emailText, password: passwordText, completion: completion)
    }
    // Create
    static func createUser(user: AuthRegisterModel, completion: @escaping(Error?) -> Void) {
        guard let profileImageData = user.profileImage.jpegData(compressionQuality: 0.5) else { return }
        let fileName = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "images/profile_images/\(fileName)")
        reference.putData(profileImageData) { metaData, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }
            reference.downloadURL { url, error in
                if let error = error {
                    print("Error : \(error.localizedDescription)")
                    return
                }
                guard let profileImageUrl = url?.absoluteString else { return }
                Auth.auth().createUser(withEmail: user.emailText, password: user.passwordText) { result, error in
                    guard let uid = result?.user.uid else { return }
                    let data = [
                        "email": user.emailText,
                        "username": user.usernameText,
                        "name": user.nameText,
                        "profileImageUrl": profileImageUrl,
                        "uid": uid
                    ] as [String: Any]
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                }
            }
        }
    }
}

