//
//  FavoriteViewController.swift
//  Movie Search App
//
//  Created by Justin Guyton on 2/27/17.
//  Copyright © 2017 Justin Guyton. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favorites: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.favorites.dataSource = self
        self.favorites.delegate = self
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
    
    
    func tableView(_ favTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return favMovies.count
        if UserDefaults.standard.object(forKey: "Favorites") == nil {
            UserDefaults.standard.set([String](), forKey: "Favorites")
            return 1;
        
        } else {
        return (UserDefaults.standard.object(forKey: "Favorites") as! [String]).count
        }
    }
    
    func tableView(_ favTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = (UserDefaults.standard.object(forKey: "Favorites") as! [String])[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites.reloadData()
    }
    
    func tableView(_ favTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //alert confirm
            let alert = UIAlertController(title: title, message: "Are you sure you would like to delete from favorites?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
                self.favorites.beginUpdates()
                self.favorites.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
                if var userFav: [String] = UserDefaults.standard.object(forKey: "Favorites") as? [String] {
                    userFav.remove(at: indexPath.row)
                    UserDefaults.standard.object(forKey: "Favorites")
                    UserDefaults.standard.set(userFav, forKey: "Favorites")
                }
                self.favorites.reloadData()
                self.favorites.endUpdates()
            }))
           
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func clearAllFav(_ sender: Any) {
        
        //alert confirm
        let alert = UIAlertController(title: title, message: "Are you sure you would like to delete from favorites?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            if var userFav: [String] = UserDefaults.standard.object(forKey: "Favorites") as? [String] {
                userFav.removeAll()
                UserDefaults.standard.object(forKey: "Favorites")
                UserDefaults.standard.set(userFav, forKey: "Favorites")
            }
            self.favorites.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
        

    }
}
