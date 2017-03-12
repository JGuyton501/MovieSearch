//
//  MovieViewController.swift
//  Movie Search App
//
//  Created by Justin Guyton on 2/16/17.
//  Copyright © 2017 Justin Guyton. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var movieSearch: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var movieData: [Movie] = []
    var movieDetails: [MovieDetails] = []
    var movieImg: [UIImage] = []
    var search: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieCollection.dataSource = self
        movieCollection.delegate = self
        movieSearch.delegate = self

//        loadData("tony")
//        self.spinner.startAnimating()
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
    
    //Note to self: need the following two functions for UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movie", for: indexPath) as! MovieCell
        cell.image = movieImg[indexPath.row]
        cell.movieLabel.text = movieData[indexPath.row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print (movieData.count)
//        print (movieImg.count)
//        print (movieDetails.count)
        return movieData.count
    }
    
    func loadData(_ searchText:String){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
            
            //new queue parallel to the main
            //place anything time consuming make 2
            self.fetchData(searchText, page: 1)
            self.fetchData(searchText, page: 2)
            self.cacheImg()
            
            //async callback, used to render the content of the page
            DispatchQueue.main.async{
                //render the content
                self.movieCollection.reloadData()
                //stop animating after data render
                self.spinner.stopAnimating()
            }
        }
    }
    
    func fetchData(_ searchText:String,page:Int){
        let json = getJSON("http://www.omdbapi.com/?s=\(searchText)&page=\(page)")
        let jsonContent = json["Search"].arrayValue

        for item in jsonContent{
            let year = item["Year"].intValue
            let type = item["Type"].stringValue
            let title = item["Title"].stringValue
            let imdbID = item["imdbID"].stringValue
            let poster = item["Poster"].stringValue
           
            let jsonSeg = getJSON("http://www.omdbapi.com/?i=\(imdbID)")
            let release = jsonSeg["Released"].stringValue
            let score = jsonSeg["Metascore"].stringValue
            let rating = jsonSeg["imdbRating"].stringValue
            let plot = jsonSeg["Plot"].stringValue

            movieData.append(Movie(year: year, type: type, title: title, imdbID: imdbID, poster: poster))
            movieDetails.append(MovieDetails(released: release, score: score, rating: rating, plot: plot))
        }
    }
    
    func cacheImg() {
        for item in movieData {
            if (item.poster == "N/A") {
                movieImg.append(UIImage(named:"no-image")!)
            } else{
                let url = URL(string: item.poster)
                let data = try? Data(contentsOf: url!)
                if let image = UIImage(data: data!) {
                    movieImg.append(image)
                } else{
                    movieImg.append(UIImage(named:"no-image")!)
                }
            }
        }
    }
    
    //movie search clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search = movieSearch.text!
        if search != "" {
            movieData = []
            movieDetails = []
            movieImg = []
            let movieSearch = search?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            loadData(movieSearch!)
            self.spinner.startAnimating()

        }
    }
    
    fileprivate func getJSON(_ url: String) -> JSON {
        //print(url)
        if let nsurl = URL(string: url){
            if let data = try? Data(contentsOf: nsurl) {
                let json = JSON(data: data)
                return json
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    //segue prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if (identifier == "details") {
                if let vc = segue.destination as? MovieDetailsViewController {
                    let selectedIndex = self.movieCollection.indexPath(for: sender as! UICollectionViewCell)
                    vc.id = movieData[selectedIndex!.row].imdbID
                    vc.title = movieData[selectedIndex!.row].title
                    vc.imageSeg = movieImg[selectedIndex!.row]
                    vc.releasedSeg = movieDetails[selectedIndex!.row].released
                    vc.scoreSeg = movieDetails[selectedIndex!.row].score
                    vc.ratingSeg = movieDetails[selectedIndex!.row].rating
                    vc.plotSeg = movieDetails[selectedIndex!.row].plot
                }
            }
        }
    }

}
