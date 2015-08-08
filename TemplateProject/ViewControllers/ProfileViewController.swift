//
//  ProfileViewController.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var sectionTitles = [ "Settings & Feedback" ]
    
    var sectionData = [["About", "Send Feedback", "Review on the App Store", "Log Out" ]]

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var emailAddress: UILabel!
    
    let user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerNib(UINib(nibName: "ProfileSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ProfileSectionHeader")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        userName.text = user!.username
        emailAddress.text = user!.email
        
        if let urlString = user?.valueForKey("profilePicture") as? String, url = NSURL(string: urlString) {
            self.profileImage.layer.masksToBounds = true;
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2;
            profileImage.sd_setImageWithURL(url)
//            profileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "NAME"))
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 22)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
       
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["mukatay.darhan@gmail.com"])
        mailComposerVC.setSubject("Linker feedback")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserProfileCell", forIndexPath: indexPath) as! ProfileTableViewCell
        let value = sectionData[indexPath.section][indexPath.row]
        cell.titleLabel.text = value
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("ProfileSectionHeader") as! ProfileSectionHeader
        headerView.titleLabel.text = sectionTitles[section]
        return headerView
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewControllerWithIdentifier("About") as! UIViewController
            navigationController?.pushViewController(destination, animated: true)

        }else if indexPath.row == 1 {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }

        }else if indexPath.row == 2 {
            
            let appStoreURL = NSURL(string: "itms-apps://itunes.apple.com/app/id=1028675163?mt=8")
            UIApplication.sharedApplication().openURL(appStoreURL!)
            
        }else if indexPath.row == 3 {
            PFUser.logOut()
            
            let loginViewController = MyLoginViewController()
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
        
    }
    
}



