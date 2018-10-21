//
//  Extensions.swift
//  Yo.ListOfBestFilms
//
//  Created by Сергей on 21/10/2018.
//  Copyright © 2018 Sergei Kononov. All rights reserved.
//

import Foundation
import UIKit


// Search index
extension Array where Element: Equatable {
    
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter { element == $0.element }.map { $0.offset }
    }
    
}

// Download image from network
extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
}
