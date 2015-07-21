//
//  ProfileViewController.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var emailAddress: UILabel!
    
    let user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        userName.text = user!.username
        emailAddress.text = user!.email
        
        if let image = PFUser.currentUser()?.valueForKey("profilePicture") as? PFFile{
                image.getDataInBackgroundWithBlock{ (data: NSData?, error: NSError?) -> Void in
                    if let data = data {
                        if let error = error {
                            ErrorHandling.defaultErrorHandler(error)
                        }
                        
                        let image = UIImage(data: data, scale: 1.0)!
                        self.profileImage.layer.masksToBounds = true;
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2;
                        self.profileImage.image = image
                }
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserProfileCell", forIndexPath: indexPath) as! ProfileTableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

