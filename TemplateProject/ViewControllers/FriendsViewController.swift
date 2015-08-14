//
//  FriendsViewController.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/21/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Social
import Parse
import FBSDKShareKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    var friendsData: [FBUser] = []
    var filtered:[FBUser] = []
    var searchActive : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tintColor = UIColor(red: 10/255.0, green: 194/255.0, blue: 90/255.0, alpha: 1.0)

        tableView.dataSource = self
        tableView.delegate =  self
        searchBar.delegate = self
        
        self.tableView.allowsMultipleSelection = true
                FBSDKGraphRequest(graphPath: "/me/taggable_friends", parameters: ["limit" : "5000"], HTTPMethod: "GET").startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
            if error == nil {
                if let data = result?["data"] as? [[String: AnyObject]] {
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 22)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
}

extension FriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filtered.count
        }
        return friendsData.count    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var friend = friendsData[indexPath.row]
        if(searchActive){
            friend = filtered[indexPath.row]
        }
        
        cell.friendUsername.text = friend.username

        if let urlString = friend.profilePic, url = NSURL(string: urlString) {
            cell.friendPicture.layer.masksToBounds = true;
            cell.friendPicture.layer.cornerRadius = cell.friendPicture.frame.height/2;
//            cell.friendPicture.sd_setImageWithURL(url)
            cell.friendPicture.sd_setImageWithURL(url, placeholderImage: UIImage(named: "ProfilePlaceholder"))
        }
        return cell
    }
}

extension FriendsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchActive = true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let options = NSStringCompareOptions.CaseInsensitiveSearch
        if searchText == "" {
            searchActive = false
        } else {
            filtered = filter(friendsData){ $0.username.rangeOfString(searchText, options: options) != nil }
            searchActive = true
        }
        
        self.tableView.reloadData()
    }
}