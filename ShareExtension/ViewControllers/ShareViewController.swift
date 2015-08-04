//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Darkhan Mukatay on 7/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Social
import CoreGraphics
import Parse

class ShareViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var friendsArray: [FBUser]
    var friendsFbId: [String]
    
    required init(coder aDecoder: NSCoder) {
        self.friendsArray = []
        self.friendsFbId = []
        super.init(coder: aDecoder)
    }
    
    func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if(!Parse.isLocalDatastoreEnabled()){
            Parse.enableLocalDatastore()
            Parse.enableDataSharingWithApplicationGroupIdentifier("group.mukatay.TestShareDefaults", containingApplication: "Make-School.TemplateProject.ShareExtension")
            Parse.setApplicationId("ErcD8FgZDmstg9zQfZ2HVCrJ1JwXFWPCdFZerCgJ", clientKey: "bybCVI9UELUynBuJqSWPxNxTJ3AeFJM1zA9oYVF4")
            PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(nil)

            if let serializedAccessToken = NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.objectForKey("FacebookAccessToken") as? NSData
            {
                if let accessToken = NSKeyedUnarchiver.unarchiveObjectWithData(serializedAccessToken) as? FBSDKAccessToken
                {
                    if let user = PFUser.currentUser()
                    {
                        PFFacebookUtils.linkUserInBackground(user, withAccessToken: accessToken, block: { (success, error) -> Void in
                            if success {
                                println("Facebook session was linked to Parse user in extension")
                            } else {
                                println("Failed to link Facebook session to Parse user because: \(error)")
                            }
                        })
                    }
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        var input = self.extensionContext?.inputItems.first as! NSExtensionItem
        var itemProvider = input.attachments?.first as! NSItemProvider
        itemProvider.loadItemForTypeIdentifier("public.url", options: nil) { obj, error -> Void in
            
            let url = obj as! NSURL
            
            var properties = [
                "og:url": url.absoluteString!
            ]
        
            if FBSDKAccessToken.currentAccessToken() != nil {
                if(FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions")){
                    
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    let action = FBSDKShareOpenGraphAction()
                    action.actionType = "news.publishes"
                    action.setObject(object, forKey: "news.read")
                    
                    let content = FBSDKShareOpenGraphContent()
                    content.action = action
                    for  var index = 0; index < self.friendsArray.count; index++ {
                        let id = self.friendsArray[index].fbId
                        self.friendsFbId.append(id)
                    }
                    content.peopleIDs = self.friendsFbId
                    action.setObject(object, forKey: "news.read")
                    FBSDKShareAPI.shareWithContent(content, delegate: nil)
                }
            } else {
                PFFacebookUtils.linkUserInBackground(PFUser.currentUser()!, withPublishPermissions: ["publish_actions"], block: { (success, error) -> Void in
                    if success {
                        println("User linked withPublishPermissions")
                    }
                })
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configurationItems() -> [AnyObject]! {
        return []
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "show") {
            
            let friendListViewController = segue.destinationViewController as! FriendsListViewController
            var checked : [String : Bool] = [String : Bool]()
            for user in self.friendsArray {
                checked[user.username] = true
            }
            friendListViewController.checked = checked
        }
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        if (segue.identifier == "done") {
            let friendListViewController = segue.sourceViewController as! FriendsListViewController
            self.friendsArray = friendListViewController.getSelectedUsers()
            self.tableView.reloadData()
        }
    }
}
extension ShareViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + friendsArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as! SharingContentTableViewCell
            var input = self.extensionContext?.inputItems.first as! NSExtensionItem
            var title = input.attributedContentText
            
            cell.linkTitle.lineBreakMode = .ByWordWrapping
            cell.linkTitle.numberOfLines = 0
            cell.linkTitle.text = title?.string
            cell.linkTitle.sizeToFit()
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ShowFriendsCell", forIndexPath: indexPath) as! ShowFriendsTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectedFriendCell", forIndexPath: indexPath) as! SelectedFriendTableViewCell
            var friend = friendsArray[indexPath.row - 2]
            cell.friendUsername.text = friend.username
            
            if let urlString = friend.profilePic, url = NSURL(string: urlString) {
                cell.friendProfilePic.layer.masksToBounds = true;
                cell.friendProfilePic.layer.cornerRadius = cell.friendProfilePic.frame.height/2;
                cell.friendProfilePic.sd_setImageWithURL(url)
//              profileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "NAME"))
            }
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 174
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.friendsArray.removeAtIndex(indexPath.row - 2)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.reloadData()
        }
    }
}


