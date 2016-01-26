//
//  ViewController.swift
//  Flicks
//
//  Created by Carl Chen on 1/11/16.
//  Copyright © 2016 Zhen Chen. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var netWorkErrorView: UIView!

    var mvs:[NSDictionary]?
    var movies:[NSDictionary]?
    let alert = UIAlertController(title: nil , message: "Loading", preferredStyle: .Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        apiRequest()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func tapNetworkError(sender: UITapGestureRecognizer) {
        self.presentViewController(alert, animated: true, completion: nil)
        
        apiRequest()
    }
    
    func apiRequest() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    self.netWorkErrorView.hidden = true
                    self.collectionView.hidden = false
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //NSLog("response: \(responseDictionary)")
                            self.mvs = responseDictionary["results"] as? [NSDictionary]
                            self.movies = self.mvs
                            self.alert.dismissViewControllerAnimated(true, completion: nil)
                            self.collectionView.reloadData()
                    }
                } else {
                    self.alert.dismissViewControllerAnimated(true, completion: nil)
                    self.collectionView.hidden = true
                    self.netWorkErrorView.hidden = false
                }
        });
        task.resume()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        self.presentViewController(alert, animated: true, completion: nil)
        apiRequest()
        
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: indexPath.item)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let index = sender as! Int
        let movie = movies![index]
        let destViewController = segue.destinationViewController as! DetailViewController
        //destViewController.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.hidden = true
        destViewController.imagePath = movie["poster_path"] as! String
        destViewController.labelTitle = movie["title"] as! String
        destViewController.overview = movie["overview"] as! String
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width-10)/2
        return CGSizeMake(width, width*7.5/5)

    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MovieCollectionViewCell
        let movie = movies![indexPath.item]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.blueColor()
        cell.selectedBackgroundView = backgroundView
        let url1 = "http://image.tmdb.org/t/p/w500/"
        
        if let imagePath = movie["poster_path"] as? String {
            let imageURL = NSURL(string: url1 + imagePath)
            
            let urlRequest = NSURLRequest(URL: imageURL!)
            //let largeImageRequest = NSURLRequest(URL: NSURL(string: url2 + imagePath)!)
            
            cell.image.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                // response is nil when image returned from cache
                
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.image.alpha = 0
                    cell.image.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.image.alpha = 1
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.image.image = image
                }
                
                }, failure: { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) -> Void in
                    // do something for the failure condition
            })
        }
        
        //cell.image.image = UIImage()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        movies = searchText.isEmpty ? mvs : mvs?.filter({(movie: NSDictionary) -> Bool in
            if let title = movie["title"] as? String {
                return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            }
            return false
        })
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        movies = mvs
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true;
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}

