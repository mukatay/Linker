//
//  MyLoginViewController.swift
//  Linker
//
//  Created by Darkhan Mukatay on 8/7/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import ParseUI

class MyLoginViewController: PFLogInViewController {

    //var loginView: PFLogInView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logInView?.backgroundColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)

        self.logInView?.logo = UIImageView(image: UIImage(named: "Launch screen"))
        
        self.logInView?.facebookButton?.layer.masksToBounds = false
        self.logInView?.facebookButton?.setImage(nil, forState: .Normal)
        self.logInView?.facebookButton?.setImage(nil, forState: .Highlighted)
        self.logInView?.facebookButton?.setBackgroundImage(nil, forState: .Normal)
        self.logInView?.facebookButton?.setBackgroundImage(nil, forState: .Highlighted)
        self.logInView?.facebookButton?.backgroundColor = UIColor(red: 0/255.0, green: 166/255.0, blue: 72/255.0, alpha: 1.0)

        let titleAttributes = [ NSFontAttributeName as NSString : UIFont(name: "Avenir", size: 20)!,
                                 NSForegroundColorAttributeName : UIColor.whiteColor() ]
        let attributedTitle = NSAttributedString(string: "Log in with Facebook", attributes: titleAttributes)
        self.logInView?.facebookButton?.setAttributedTitle(attributedTitle, forState: .Normal)
        self.logInView?.facebookButton?.layer.shadowColor = UIColor.blackColor().CGColor
        self.logInView?.facebookButton?.layer.shadowOffset = CGSizeMake(0, 2)
        self.logInView?.facebookButton?.layer.shadowRadius = 4
        self.logInView?.facebookButton?.layer.shadowOpacity = 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.logInView?.logo?.frame = CGRectMake(67.0, 143.0, 195.0, 199.0)
        self.logInView?.facebookButton?.frame = CGRectMake(19.0, 370.0, 283.0, 50.0)
        
        
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
