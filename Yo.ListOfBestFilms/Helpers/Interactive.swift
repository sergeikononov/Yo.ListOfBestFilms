//
//  Interactive.swift
//  Yo.ListOfBestFilms
//
//  Created by Сергей on 21/10/2018.
//  Copyright © 2018 Sergei Kononov. All rights reserved.
//

import Foundation
import UIKit

// Show alerts

func showAlertWithOk(_ owner: UIViewController, title: String, message: String) {
    let alert  = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(action)
    owner.present(alert, animated: true, completion: nil)
}
