//
//  ViewController.swift
//  Stars
//
//  Created by Angela Yu on 3/4/18.
//  Copyright © 2018 Angela Yu. All rights reserved.
//

import UIKit
import AFNetworking

class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var discoverCollection: UICollectionView!
    
    var moviesDict: [[String: Any]] = [[String: Any]]()
    var endpoint: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateWidths()
        discoverCollection.dataSource = self
        discoverCollection.delegate = self
        
        networkRequest(endpoint: endpoint!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        // MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if error != nil {
//                // Display error view
//                self.errorView.isHidden = false
//                self.refreshControl.endRefreshing()
//                self.refreshCollectionControl.endRefreshing()
                
                // Hide HUD to allow refresh
//                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
//                self.errorView.isHidden = true
                if let data = dataOrNil {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    
                    self.moviesDict = dictionary["results"] as! [[String: Any]]
//                    self.moviesTable.reloadData()
                    self.discoverCollection.reloadData()
//                    self.refreshControl.endRefreshing()
//                    self.refreshCollectionControl.endRefreshing()
                    
                    // Hide HUD once the network request comes back
//                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        });
        task.resume()
        
    }
    
    func calculateWidths() {
        // Calculate cell size to make collection lay out in 3 columns
        let posterwidth = (discoverCollection.frame.width / 3) - 4
        let posterheight = (posterwidth * 1.5) + 30
        let cellSize = CGSize(width: posterwidth, height: posterheight)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        discoverCollection.setCollectionViewLayout(layout, animated: true)
        discoverCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCell", for: indexPath) as! DiscoverCollectionViewCell
        let movie = moviesDict[indexPath.row]
        let title: String = movie["title"] as! String
        cell.titleLabel.text = title
        
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            cell.loadImage(imageVue: cell.posterView, imageUrl: posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that will be included as an asset
            cell.posterView.image = nil
        }
        
        return cell
    }
    
    // Customize selected behavior for collectionview
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = discoverCollection.cellForItem(at: indexPath) as! DiscoverCollectionViewCell
        cell.backgroundColor = UIColor.darkGray
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = discoverCollection.cellForItem(at: indexPath) as! DiscoverCollectionViewCell
        cell.backgroundColor = UIColor.black
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
