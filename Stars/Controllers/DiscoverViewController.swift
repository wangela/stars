//
//  ViewController.swift
//  Stars
//
//  Created by Angela Yu on 3/4/18.
//  Copyright © 2018 Angela Yu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import SwiftyJSON
import youtube_ios_player_helper

class DiscoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var discoverTableView: UITableView!
    
    var orientation: UIDeviceOrientation = .unknown
    var moviesDict: [[String: Any]] = [[String: Any]]()
    var endpoint: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discoverTableView.dataSource = self
        discoverTableView.delegate = self
        
        networkRequest(endpoint: endpoint!)
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.isTranslucent = false
            navigationBar.barStyle = UIBarStyle.black
            navigationBar.titleTextAttributes = [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin),
                NSAttributedStringKey.foregroundColor: UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 13.0/255.0, alpha: 1.0)
            ]
        }
        self.title = "Now Playing"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
        // Initial device orientation
        self.orientation = UIDevice.current.orientation
        discoverTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        if UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - API calls
    func networkRequest(endpoint: String) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/\(endpoint)?api_key=\(apiKey)")
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD just before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if error != nil {
                //                // Display error view
                //                self.errorView.isHidden = false
                //                self.refreshControl.endRefreshing()
                //                self.refreshCollectionControl.endRefreshing()
                
                // Hide HUD to allow refresh
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                //                self.errorView.isHidden = true
                if let data = dataOrNil {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    //                    let json = JSON(data)
                    //                    if let results = json["results"].dictionary {
                    //                        self.moviesDict = results
                    //                    }
                    self.moviesDict = dictionary["results"] as! [[String : Any]]
                    print(self.moviesDict)
                    self.discoverTableView.reloadData()
                    //                    self.refreshControl.endRefreshing()
                    //                    self.refreshCollectionControl.endRefreshing()
                    
                    // Hide HUD once the network request comes back
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        });
        task.resume()
        
    }
    
    func fetchTrailer(movieID: Int) -> String {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let idString = String(movieID)
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(idString)/videos?api_key=\(apiKey)")
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        var trailerKey: String = ""
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if error != nil {
                //                // Display error view
                //                self.errorView.isHidden = false
                //                self.refreshControl.endRefreshing()
                //                self.refreshCollectionControl.endRefreshing()
                
            } else {
                //                self.errorView.isHidden = true
                if let data = dataOrNil {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    //                    let json = JSON(data)
                    //                    if let results = json["results"].dictionary {
                    //                        self.moviesDict = results
                    //                    }
                    let trailersList = dictionary["results"] as! [[String : Any]]
                    trailerKey = trailersList[0]["key"] as! String
                }
            }
        });
        task.resume()
        
        return trailerKey
    }
    
    // MARK: - TableView Data Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UIDeviceOrientationIsLandscape(orientation) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverLandscapeCell", for: indexPath) as! DiscoverLandscapeCell
            
            let movie = moviesDict[indexPath.row]
            if let title: String = movie["title"] as? String {
                cell.movieTitleLabel.text = title
            }
            if let description: String = movie["overview"] as? String {
                cell.movieDescriptionLabel.text = description
            }
            
            let movieIDNum = movie["id"] as! Int
            let videoKey = fetchTrailer(movieID: movieIDNum)
            cell.trailerView.load(withVideoId: videoKey)
//            let videoUrl = URL(string: "https://www.youtube.com/embed/\(videoKey)")
//            cell.trailerView.loadRequest(URLRequest(url: videoUrl!))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! DiscoverPortraitCell
            
            let movie = moviesDict[indexPath.row]
            if let title: String = movie["title"] as? String {
                cell.movieTitleLabel.text = title
            }
            if let description: String = movie["overview"] as? String {
                cell.movieDescriptionLabel.text = description
            }
            
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            guard let posterPath = movie["poster_path"] as? String, let posterUrl = URL(string: posterBaseUrl + posterPath) else {
                // No poster image. Can either set to nil (no image) or a default movie poster image
                // that will be included as an asset
                cell.posterImageView.image = nil
                return cell
            }
            cell.loadImage(for: cell.posterImageView, from: posterUrl)
            
            return cell
        }
        
    }
    
    // Customize selected behavior for cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DiscoverPortraitCell
        cell.backgroundColor = UIColor.darkGray
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DiscoverPortraitCell
        cell.backgroundColor = UIColor.black
    }
    
    // MARK: - Device Rotation
    @objc func deviceDidRotate(notification: NSNotification) {
        self.orientation = UIDevice.current.orientation
        
        discoverTableView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
