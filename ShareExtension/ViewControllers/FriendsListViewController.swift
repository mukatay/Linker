//
//  FriendsListViewController.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/23/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Social

class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    var friendsData : [FBUser] = []
    
    var checked = [String: Bool]()
    var searchActive : Bool = false
    var filtered:[FBUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate =  self
        searchBar.delegate = self
        
        self.tableView.allowsMultipleSelection = true
        
        if let fbData = NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")!.objectForKey("FBData") as? [AnyObject] {
//            println("FBFriends are: \(fbData)")
            
                for object in fbData {
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
    }
}

extension FriendsListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filtered.count
        }
        return friendsData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendsListCell", forIndexPath: indexPath) as! FriendsListTableViewCell
        var friend = friendsData[indexPath.row]
        if(searchActive){
            friend = filtered[indexPath.row]
        }
        cell.friendListUsername.text = friend.username
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        if checked[friend.username] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        if let urlString = friend.profilePic, url = NSURL(string: urlString) {
            cell.friendListPicture.layer.masksToBounds = true;
            cell.friendListPicture.layer.cornerRadius = cell.friendListPicture.frame.height/2;
            cell.friendListPicture.sd_setImageWithURL(url)
//          profileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "NAME"))
        }
        return cell
    }
}

extension FriendsListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendsListTableViewCell
        if searchActive {
            checked[filtered[indexPath.row].username] = true
        } else {
            checked[friendsData[indexPath.row].username] = true
        }
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendsListTableViewCell
        if searchActive {
            checked[filtered[indexPath.row].username] = true
        } else {
            checked[friendsData[indexPath.row].username] = true
        }
        cell.accessoryType = UITableViewCellAccessoryType.None
    }
    
    private func getSelectedUsers()->[FBUser] {
        var selectedUsers : [FBUser] = []
        for friend in friendsData {
            if checked[friend.username] == true {
                selectedUsers.append(friend)
            }
            
            // Do whatever you want
        }
        return selectedUsers
    }
}

extension FriendsListViewController: UISearchBarDelegate {
    
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



