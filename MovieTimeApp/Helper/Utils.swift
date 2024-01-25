//
//  Utils.swift
//  MovieApp
//
//  Created by Caner Karabulut on 16.01.2024.
//

import UIKit
import JGProgressHUD

extension UIViewController{
    func backgroundGradientColor(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBackground.cgColor, UIColor.secondarySystemBackground.cgColor]
        gradient.locations = [0,1]
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    func alertMessage(alertTitle: String, alertMesssage: String, completionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: alertTitle, message: alertMesssage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler?() 
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func hideAndShowButtonConfiguration(textField: UITextField, button: UIButton) {
        if textField.isSecureTextEntry == true {
            textField.isSecureTextEntry = false
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }else{
            textField.isSecureTextEntry = true
            button.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    func showHud(show: Bool) {
        view.endEditing(true)
        let jgProgressHud = JGProgressHUD(style: .dark)
        jgProgressHud.textLabel.text = "Loading..."
        jgProgressHud.detailTextLabel.text = "Please Wait"
        if show {
            jgProgressHud.show(in: view)
        }else {
            jgProgressHud.dismiss(afterDelay: 1.0)
        }
    }
    func add(_ child: UIViewController) {
        addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: self)
        self.view.removeFromSuperview()
        removeFromParent()
    }
}
