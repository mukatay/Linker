//
//  FriendsListViewController.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/23/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Social

class FriendListViewController: UITableViewController {
 
    @IBOutlet var tableVieww: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fbData = NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")!.objectForKey("FBData") as? [AnyObject] {
//            println("FBFriends are: \(fbData)")
            
//                for object in fbData {
//                    if let username = object["name"] as? String, id = object["id"] as? String {
//                        let picture = object["picture"] as? [String: AnyObject]
//                        let pictureData = picture?["data"] as? [String: AnyObject]
//                        let pictureUrl = pictureData?["url"] as? String
//                        let friend = FBUser(username: username, fbId: id, profilePic: pictureUrl)
//                        self.friendsData.append(friend)
//                    }
//                }
//                self.tableView.reloadData()
    
        }
    }
}
    



