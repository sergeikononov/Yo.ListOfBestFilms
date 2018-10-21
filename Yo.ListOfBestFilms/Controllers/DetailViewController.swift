//
//  DetailViewController.swift
//  Yo.ListOfBestFilms
//
//  Created by Сергей on 18/10/2018.
//  Copyright © 2018 Sergei Kononov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var film: Film!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var raiting: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if film.imageURL != "" {
            image.downloadedFrom(link: film.imageURL!)
            if image.image == nil {
                image.image = UIImage(named: "noimage")
            }
        } else {
            image.image = UIImage(named: "noimage")
        }
        
        name.text = film.name
        year.text = String(film.year)
        raiting.text = "Рейтинг: " + String(film.rating!)
        if film.description != "" {
            desc.text = String(film.description!)
        } else {
            desc.text = "No description"
        }
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


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
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
