//
//  TrailerCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 16.01.2024.
//

import UIKit
import WebKit

class TrailerCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "TrailerCell"
    
    public var trailerWebView : WKWebView!
    
    private let webView: WKWebView = {
       let webView = WKWebView()
        return webView
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension TrailerCell {

    private func style() {
        webView.translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = .secondarySystemBackground
            layer.cornerRadius = 12
            layer.shadowColor = UIColor.label.cgColor
            layer.shadowOpacity = 0.9
            layer.shadowOffset = CGSize(width: -4, height: -4)
    }
    private func layout() {
        addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    func configure(with video: VideoResults?) {
        guard let videoKey = video?.key else {
            return
        }
        let videoURLString = "https://www.youtube.com/embed/\(videoKey)"
        if let videoURL = URL(string: videoURLString) {
            let request = URLRequest(url: videoURL)
            webView.load(request)
        }
    }
}
