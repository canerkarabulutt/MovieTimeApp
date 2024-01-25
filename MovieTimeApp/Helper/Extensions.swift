//
//  Extensions.swift
//  MovieApp
//
//  Created by Caner Karabulut on 21.12.2023.
//

import UIKit

extension UIImageView {
    func customMode() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    func customScreenPage() {
        layer.cornerRadius = 12
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.85
    }
    func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
            }
            DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
extension UIColor{
    static let mainColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
}
