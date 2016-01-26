//
//  DetailViewController.swift
//  Flicks
//
//  Created by Carl Chen on 1/24/16.
//  Copyright © 2016 Zhen Chen. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    @IBOutlet weak var overviewText: UITextView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var imagePath:String = ""
    var labelTitle:String = ""
    var overview:String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = labelTitle
        overviewText.text = overview
        overviewText.textColor = UIColor.whiteColor()
        overviewText.font = UIFont.systemFontOfSize(19)
        //textView.text = overview
        titleLabel.text = labelTitle
        //backgroundImage.setImageWithURL(NSURL(string: imageurl)!)
        
        let url1 = "https://image.tmdb.org/t/p/w45"
        let url2 = "https://image.tmdb.org/t/p/original"
        let imageURL = NSURL(string: url1 + imagePath)
        
        let urlRequest = NSURLRequest(URL: imageURL!)
        let largeImageRequest = NSURLRequest(URL: NSURL(string: url2 + imagePath)!)
        
        backgroundImage.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
            // response is nil when image returned from cache
            
            
            self.backgroundImage.alpha = 0
            self.backgroundImage.image = image
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.backgroundImage.alpha = 1
                }
                , completion: { (sucess) -> Void in
                    self.backgroundImage.setImageWithURLRequest(
                        largeImageRequest,
                        placeholderImage: image,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.backgroundImage.image = largeImage;
                            
                        },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
            })

            
            }, failure: { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) -> Void in
                // do something for the failure condition
        })
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
