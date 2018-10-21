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
        
    }

}
