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
        
        self.logInView?.logo?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.logInView?.facebookButton?.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if let logInView = self.logInView, facebookButton = self.logInView?.facebookButton, logo = self.logInView?.logo {
            
            if logInView.constraints().count == 0 {
            
                logo.contentMode = .Center
                logo.sizeToFit()
                
                let topConstraint = NSLayoutConstraint(item: logo, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: logInView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 130.0)
                logInView.addConstraint(topConstraint)
                
                let xConstraint = NSLayoutConstraint(item: logo, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: logInView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 8)
                logInView.addConstraint(xConstraint)
                
                let topFbConstraint = NSLayoutConstraint(item: facebookButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: logInView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 380)
                logInView.addConstraint(topFbConstraint)
                
                let widthFbConstraint = NSLayoutConstraint(item: facebookButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 280)
                logInView.addConstraint(widthFbConstraint)
                
                let centerFbConstraint = NSLayoutConstraint(item: facebookButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: logInView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
                logInView.addConstraint(centerFbConstraint)
            }
            
            logo.setNeedsLayout()
            logo.layoutIfNeeded()
        }
    }
}
