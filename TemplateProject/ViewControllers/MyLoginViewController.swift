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
        
    }
    
    override func viewDidLayoutSubviews() {
 
        
        if let logInView = self.logInView, facebookButton = self.logInView?.facebookButton, logo = self.logInView?.logo {
            
            logo.sizeToFit()
            
            let topConstraint = NSLayoutConstraint(item: logo, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: logInView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 143.0)
            logInView.addConstraint(topConstraint)
            
            let xConstraint = NSLayoutConstraint(item: logo, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: logInView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            view.addConstraint(xConstraint)
            
            let topFbConstraint = NSLayoutConstraint(item: facebookButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: logInView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 283.0)
            logInView.addConstraint(topFbConstraint)
            
            let leftFbConstraint = NSLayoutConstraint(item: facebookButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: logInView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
            logInView.addConstraint(leftFbConstraint)
            
            let rightFbConstraint = NSLayoutConstraint(item: facebookButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: logInView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 20)
            logInView.addConstraint(rightFbConstraint)
            
        }
        
    }
}
