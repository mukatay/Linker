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
import MobileCoreServices


class ShareViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var friendsTextField: UITextField!
    
    func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    @IBOutlet weak var friendsTableViewCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableViewCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        var input = self.extensionContext?.inputItems.first as! NSExtensionItem
        var title = input.attributedContentText
        
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = title?.string
        titleLabel.sizeToFit()
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
