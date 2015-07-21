//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Darkhan Mukatay on 7/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var popUpView: UIView!
    

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
    
    @IBAction func cancelButton(sender: UIButton) {
        
    }
    
    @IBAction func shareButton(sender: UIButton) {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    
//        var title = self.contentText
//        println("Hello:  \(title)")

        
        NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.setObject(title, forKey: "webTitle")
        NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.synchronize()
        
        var input = self.extensionContext?.inputItems.first as! NSExtensionItem
        var itemProvider = input.attachments?.first as! NSItemProvider
        itemProvider.loadItemForTypeIdentifier("public.url", options: nil) { obj, error -> Void in
            
            let url = obj as! NSURL
            
            println(url.absoluteString)
            
            NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.setObject(url.absoluteString, forKey: "webURL")
            NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.synchronize()
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
            
        }
    }

    func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
//    func setPresentationStyleForSelfController(selfController: UIViewController, presentingController: UIViewController) {
//        
//        presentingController.providesPresentationContextTransitionStyle = true;
//        presentingController.definesPresentationContext = true;
//        
//        presentingController.setModalPresentationStyle(UIModalPresentationOverCurrentContext)
//        
//    }
//
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let popup: PopUpViewController!
//        self.setPresentationStyleForSelfController(self, presentingController: popup)
//        
//    }
}
