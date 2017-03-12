//
//  Movie.swift
//  Movie Search App
//
//  Created by Justin Guyton on 2/16/17.
//  Copyright © 2017 Justin Guyton. All rights reserved.
//

import UIKit

class Movie {
    
    init(year: Int, type: String, title: String, imdbID: String, poster: String) {
        self.year = year
        self.type = type
        self.title = title
        self.imdbID = imdbID
        self.poster = poster
    }
    
    //movie data
    var year: Int
    var type: String
    var title: String
    var imdbID: String
    var poster: String
    
}
