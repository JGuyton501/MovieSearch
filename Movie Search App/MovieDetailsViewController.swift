//
//  MovieDetailsViewController.swift
//  Movie Search App
//
//  Created by Justin Guyton on 2/23/17.
//  Copyright © 2017 Justin Guyton. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var detailsImg: UIImageView!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var addToFav: UIButton!
    
    var imageSeg: UIImage!
    var releasedSeg: String!
    var scoreSeg: String!
    var ratingSeg: String!
    var id: String!
    var plotSeg: String!

    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        set()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func set(){
        navigationItem.title = title
        detailsImg.image = imageSeg
        released.text = ("Released: \(releasedSeg!) ")
        score.text = ("Metascore: \(scoreSeg!)")
        rating.text = ("IMDB Rating: \(ratingSeg!)")
        print("https://www.google.com/#tbm=shop&q=\(title!)+dvd&*")
    }
    
    @IBAction func plotSummary(_ sender: Any) {
        let alert = UIAlertController(title: title, message: plotSeg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addToFav(_ sender: Any) {
        if UserDefaults.standard.object(forKey: "Favorites") == nil {
            UserDefaults.standard.set([String](), forKey: "Favorites")
        }
        var fav = UserDefaults.standard.object(forKey: "Favorites") as! [String]
        if !fav.contains(self.title!) {
            fav.append(self.title!)
            UserDefaults.standard.set(fav, forKey: "Favorites")
        }
        
        //alert confirm
        let alert = UIAlertController(title: title, message: "Added to favorites!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        //print(fav)
    }
    
    @IBAction func share(_ sender: UIButton) {
        let textToShare = "Check out the movie \(title!)! It's amazing!"
        if let web = URL(string: "http://www.imdb.com") {
            let objectsToShare = [web, textToShare] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    @IBAction func buy(_ sender: UIButton) {
        let movieTitle = title?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        if let url = NSURL(string: "https://www.google.com/#tbm=shop&q=\(movieTitle!)+dvd&*") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
