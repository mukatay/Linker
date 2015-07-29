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

class ShareViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
    }
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        
        var input = self.extensionContext?.inputItems.first as! NSExtensionItem
        var itemProvider = input.attachments?.first as! NSItemProvider
        itemProvider.loadItemForTypeIdentifier("public.url", options: nil) { obj, error -> Void in
            
        let url = obj as! NSURL
            
        println("URL: \(url.absoluteString)")
            
        }
    }

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configurationItems() -> [AnyObject]! {
        return []
        
    }
}
extension ShareViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
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
        } else { // if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectedFriendCell", forIndexPath: indexPath) as! SelectedFriendTableViewCell
            
            return cell
        }
        
    }
}


