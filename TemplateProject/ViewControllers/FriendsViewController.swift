//
//  FriendsViewController.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/21/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse


class FriendsViewController: UIViewController {
    
    var friendsData : [FBUser] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        FBSDKGraphRequest(graphPath: "/me/taggable_friends", parameters: ["limit" : "180"], HTTPMethod: "GET").startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
            if error == nil {
                if let data = result?["data"] as? [[String: AnyObject]] {
//                    println("Friends are : \(data)")
                    NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.setObject(data, forKey: "FBData")
                    NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.synchronize()
                    
                    for object in data {
                        if let username = object["name"] as? String, id = object["id"] as? String {
                            let picture = object["picture"] as? [String: AnyObject]
                            let pictureData = picture?["data"] as? [String: AnyObject]
                            let pictureUrl = pictureData?["url"] as? String
                            let friend = FBUser(username: username, fbId: id, profilePic: pictureUrl)
                            self.friendsData.append(friend)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                println("Error Getting Friends \(error)");
            }
        }
        
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

extension FriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell") as! FriendTableViewCell
        
        let friend = friendsData[indexPath.row]
        
        cell.friendUsername.text = friend.username
        
        if let urlString = friend.profilePic, url = NSURL(string: urlString) {
            cell.friendPicture.layer.masksToBounds = true;
            cell.friendPicture.layer.cornerRadius = cell.friendPicture.frame.height/2;
            cell.friendPicture.sd_setImageWithURL(url)
//            profileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "NAME"))
        }
        
        return cell
    }
}