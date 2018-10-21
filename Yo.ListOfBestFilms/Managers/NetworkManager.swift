//
//  NetworkManager.swift
//  Yo.ListOfBestFilms
//
//  Created by Сергей on 19/10/2018.
//  Copyright © 2018 Sergei Kononov. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    func getListOfFilms(success: @escaping (_ value: [Film]?) -> Void = {_ in }, failure: @escaping (_ message: String) -> Void = {_ in }) {
        
        Alamofire.request("https://s3-eu-west-1.amazonaws.com/sequeniatesttask/films.json", method: .get).responseJSON { (response) in
            
            guard let value = response.value else {
                failure("No response")
                return
            }
            let jsonValue = JSON(value)
            
            if response.response!.statusCode == 200 {
                success(Film.fromJSON(json: jsonValue["films"].array!))
            } else {
                failure("Error with parsing data")
            }
            
        }
    }
}


