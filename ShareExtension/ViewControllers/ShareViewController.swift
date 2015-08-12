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
import MobileCoreServices

class ShareViewController: UIViewController{
    
    @IBOutlet var shareView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var friendsArray: [FBUser]
    var friendsFbId: [String]
    
    var itemProperties: [ NSObject: AnyObject]?
    
    var mostRecentFriendsViewController: FriendsListViewController?
    
    required init(coder aDecoder: NSCoder) {
        self.friendsArray = []
        self.friendsFbId = []
        super.init(coder: aDecoder)
    }
    
    func isContentValid() -> Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        
        if friendsArray.isEmpty {
            self.navigationItem.rightBarButtonItem?.enabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: .Normal)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: .Normal)
        
        if(!Parse.isLocalDatastoreEnabled()){
            Parse.enableLocalDatastore()
            Parse.enableDataSharingWithApplicationGroupIdentifier("group.mukatay.TestShareDefaults", containingApplication: "Make-School.Linker.ShareExtension")
            Parse.setApplicationId("ErcD8FgZDmstg9zQfZ2HVCrJ1JwXFWPCdFZerCgJ", clientKey: "bybCVI9UELUynBuJqSWPxNxTJ3AeFJM1zA9oYVF4")
            PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(nil)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        drawNavBarCorners()
        
        readItemFromExtension()
    }
    
    func drawNavBarCorners() {
        var capa = self.navigationController?.navigationBar.layer
        
        var bounds = capa?.bounds
        var maskPath = UIBezierPath(roundedRect: bounds!, byRoundingCorners: UIRectCorner.TopLeft | UIRectCorner.TopRight, cornerRadii: CGSizeMake(6.0, 6.0))
        
        var maskLayer = CAShapeLayer()
        maskLayer.frame = bounds!
        maskLayer.path = maskPath.CGPath
        
        capa?.addSublayer(maskLayer)
        capa!.mask = maskLayer
    }
    
    func readItemFromExtension() {
        for item: AnyObject in self.extensionContext!.inputItems {
            
            let inputItem = item as! NSExtensionItem
            
            for provider: AnyObject in inputItem.attachments! {
                
                let itemProvider = provider as! NSItemProvider
                
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                    
                    itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil) { [unowned self] (result: NSSecureCoding!, error: NSError!) -> Void in
                        
                        if let resultDict = result as? NSDictionary {
                            
                            if let results = resultDict[NSExtensionJavaScriptPreprocessingResultsKey] as? [String : AnyObject]
                            {
                                var pageDescription = (results["description"] ?? "No description") as! String
                                var pageImageURL = (results["imageURL"] ?? "default") as! String
                                var pageTitle = (results["title"] ?? "No title") as! String
                                var pageURL = (results["url"] ?? "default") as! String
                                
                                self.itemProperties = [
                                    "og:type": "article",
                                    "og:url": pageURL,
                                    "og:title": pageTitle,
                                    "og:description": pageDescription,
                                    "og:image:url": pageImageURL
                                ]
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.tableView.reloadData()
                                })
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        
        if let serializedAccessToken = NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.objectForKey("FacebookAccessToken") as? NSData
        {
            if let accessToken = NSKeyedUnarchiver.unarchiveObjectWithData(serializedAccessToken) as? FBSDKAccessToken
            {
                println("Unarchived access token with permissions: \(accessToken.permissions)")
                
                FBSDKAccessToken.setCurrentAccessToken(accessToken)
                
                if let user = PFUser.currentUser(), properties = itemProperties {
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    let action = FBSDKShareOpenGraphAction(type: "news.publishes", object: object, key: "article")
                    action.setString("true", forKey: "fb:explicitly_shared")
                    
                    let content = FBSDKShareOpenGraphContent()
                    content.action = action
                    
                    for  var index = 0; index < self.friendsArray.count; index++ {
                        let id = self.friendsArray[index].fbId
                        self.friendsFbId.append(id)
                    }
                    content.peopleIDs = self.friendsFbId
                    content.previewPropertyName = "article"
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let share = FBSDKShareAPI.shareWithContent(content, delegate: self)
                        self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
    }
    
    func configurationItems() -> [AnyObject]! {
        return []
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "show") {
            
            let friendListViewController = segue.destinationViewController as! FriendsListViewController
            mostRecentFriendsViewController = friendListViewController
            var checked : [String : Bool] = [String : Bool]()
            for user in self.friendsArray {
                checked[user.username] = true
            }
            friendListViewController.checked = checked
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if let friendsVC = mostRecentFriendsViewController {
            self.friendsArray = friendsVC.getSelectedUsers()
            self.tableView.reloadData()
            mostRecentFriendsViewController = nil
        }
        
        if !friendsArray.isEmpty {
            self.navigationItem.rightBarButtonItem?.enabled = true
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
            cell.selectionStyle = .None
            
            if let imageURLString = self.itemProperties?["og:image:url"] as? String, url = NSURL(string: imageURLString) {
                if let imageURL = NSURL(string: imageURLString), imageData = NSData(contentsOfURL: imageURL) {
                    cell.linkImage.sd_setImageWithURL(url)
                }
            }
            
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
            
            cell.selectionStyle = .None
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
        return indexPath.row > 1 // First two rows should not be deletable
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.friendsArray.removeAtIndex(indexPath.row - 2)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.reloadData()
        }
        if friendsArray.isEmpty {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
}

extension ShareViewController : FBSDKSharingDelegate
{
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
        println("Sharing completed with results: \(results)")
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        
        println("Sharing failed with error: \(error)")
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        
        println("Sharing canceled")
    }
}

