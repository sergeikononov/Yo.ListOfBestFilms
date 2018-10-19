//
//  Films.swift
//  Yo.ListOfBestFilms
//
//  Created by Сергей on 19/10/2018.
//  Copyright © 2018 Sergei Kononov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Film {
    let id: Int
    let localized_name: String
    let year: Int
    let rating: Double?
    let imageURL: String?
    let description: String?
    
    static func fromJSON(json: [JSON]) -> [Film]? {
        
        return json.compactMap{ jsonItem -> Film in
            let id = jsonItem["id"].int
            let localized_name = jsonItem["localized_name"].string
            let year = jsonItem["year"].int
            let rating = jsonItem["rating"].double
            let imageURL = jsonItem["imageURL"].string
            let description = jsonItem["description"].string
            
            return Film(id: id!,
                        localized_name: localized_name!,
                        year: year!,
                        rating: rating == nil ? 0 : rating!,
                        imageURL: imageURL == nil ? "" : imageURL!,
                        description: description == nil ? "" : description!)
        }
    }
}
