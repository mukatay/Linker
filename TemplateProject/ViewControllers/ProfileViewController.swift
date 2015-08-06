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
    
    var sections = [
        "Settings & Feedback" : ["row"]
    ]

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var emailAddress: UILabel!
    
    let user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        userName.text = user!.username
        emailAddress.text = user!.email
        
        if let urlString = user?.valueForKey("profilePicture") as? String, url = NSURL(string: urlString) {
            self.profileImage.layer.masksToBounds = true;
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2;
            profileImage.sd_setImageWithURL(url)
//            profileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "NAME"))
        }
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserProfileCell", forIndexPath: indexPath) as! ProfileTableViewCell
        
        let key = Array(sections.keys)[indexPath.section]
        let value = sections[key]![indexPath.row]
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(sections.keys)[section]
        return sections[key]!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Array(sections.keys).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(sections.keys)[section]
    }
}

