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
    var imageurl:String = ""
    var labelTitle:String = ""
    var overview:String = ""
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = labelTitle
        overviewText.text = overview
        overviewText.textColor = UIColor.whiteColor()
        overviewText.font = UIFont.systemFontOfSize(19)
        //textView.text = overview
        titleLabel.text = labelTitle
        backgroundImage.setImageWithURL(NSURL(string: imageurl)!)
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
