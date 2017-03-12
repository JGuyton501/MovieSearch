//
//  MovieDetails.swift
//  Movie Search App
//
//  Created by Justin Guyton on 2/26/17.
//  Copyright © 2017 Justin Guyton. All rights reserved.
//

import UIKit


class MovieDetails {
    init(released: String, score: String, rating: String, plot: String) {
        self.released = released
        self.score = score
        self.rating = rating
        self.plot = plot
    }
    
    //movie data
    var released: String
    var score: String
    var rating: String
    var plot: String
    
}

