//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Darkhan Mukatay on 7/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var friendsTextField: UITextField!
    
    
    func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var input = self.extensionContext?.inputItems.first as! NSExtensionItem
        var title = input.attributedContentText
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = title?.string
        titleLabel.sizeToFit()

    }
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        
        
//        NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.setObject(title, forKey: "webTitle")
//        NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.synchronize()
//        
        var input = self.extensionContext?.inputItems.first as! NSExtensionItem
        var itemProvider = input.attachments?.first as! NSItemProvider
        itemProvider.loadItemForTypeIdentifier("public.url", options: nil) { obj, error -> Void in
            
        let url = obj as! NSURL
            
        println("URL: \(url.absoluteString)")
            
//            NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.setObject(url.absoluteString, forKey: "webURL")
//            NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.synchronize()
//            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
//        
        }
    }

    func configurationItems() -> [AnyObject]! {
        return []
    }
}
