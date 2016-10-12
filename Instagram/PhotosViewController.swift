//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Enta'ard on 10/12/16.
//  Copyright © 2016 Enta'ard. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedsTableView: UITableView!
    
    var photos:[NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotosViewController.loadPhotos(refreshControl:)), for: UIControlEvents.valueChanged)
        feedsTableView.insertSubview(refreshControl, at: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! PhotoCell
        cell.feedImage.setImageWith(URL(string: parseImgLink(data: photos[indexPath.row]))!)
        return cell
    }
    
    func loadPhotos(refreshControl:UIRefreshControl){
        let accessToken = "435569061.c66ada7.d12d19c8687e427591f254586e4f3e47"
        let userId = "435569061"
        let url = URL(string: "https://api.instagram.com/v1/users/\(userId)/media/recent/?access_token=\(accessToken)")
        if let url = url {
            let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request, completionHandler:{(dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{
                        if let photoData = responseDictionary["data"] as? [NSDictionary]{
                            self.photos = photoData
                            
                            self.feedsTableView.dataSource = self
                            self.feedsTableView.delegate = self
                            self.feedsTableView.reloadData()
                            refreshControl.endRefreshing()
                            
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    func parseImgLink(data: NSDictionary) -> String {
        let imageUrl = data.value(forKeyPath: "images.standard_resolution.url") as! String
        return imageUrl
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = feedsTableView.indexPathForSelectedRow?.row
        let detailsView = segue.destination as! DetailsViewController
        detailsView.url = parseImgLink(data: photos[index!])
    }
    
}
