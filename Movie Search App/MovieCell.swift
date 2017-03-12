//
//  MovieCell.swift
//  Movie Search App
//
//  Created by Justin Guyton on 2/23/17.
//  Copyright © 2017 Justin Guyton. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    
    var image: UIImage!{
        didSet {
            movieImage.image = image
        }
    }
}
