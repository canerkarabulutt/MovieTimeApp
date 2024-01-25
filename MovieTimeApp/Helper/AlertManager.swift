//
//  AlertManager.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation
import UIKit

class AlertManager {
    static func showLoadingAlert(on viewController: UIViewController) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
        let spinnerIndicator = UIActivityIndicatorView(style: .large)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        viewController.present(alertController, animated: false, completion: nil)
        return alertController
    }
    static func showAlert(on viewController: UIViewController, title: String, message: String, completionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler?()
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
