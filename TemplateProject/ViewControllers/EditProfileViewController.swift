//
//  EditProfileViewController.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/20/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController{
    
    var keys = ["username", "email"]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    let user = PFUser.currentUser()
    
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    
    @IBAction func editProfilePicture(sender: UIButton){
        
        takePhoto()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        if let image = PFUser.currentUser()?.valueForKey("profilePicture") as? PFFile{
            image.getDataInBackgroundWithBlock{ (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    if let error = error {
                        ErrorHandling.defaultErrorHandler(error)
                    }
                    
                    let image = UIImage(data: data, scale: 1.0)!
                    self.profileImage.layer.masksToBounds = true;
                    self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2;
                    self.profileImage.image = image
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func takePhoto() {
        
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!){
            (image: UIImage?) in
            println("received a callback")
            
            self.profileImage.image = image
            
            let imageData = UIImageJPEGRepresentation(self.profileImage.image, 0.8)
            let imageFile = PFFile(data: imageData)
    
            imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
                if let error = error {
                    ErrorHandling.defaultErrorHandler(error)
                }
                self.user!.setObject(imageFile, forKey: "profilePicture")
                self.user!.saveInBackground()
            }
        }
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        println("tapped")
        
        PFUser.currentUser()?.saveInBackground()
        
        self.navigationController!.popViewControllerAnimated(true)
    }
}

extension EditProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EditProfileCell", forIndexPath: indexPath) as! EditProfileTableViewCell
        
        let key = keys[indexPath.row]
        
        cell.key = key
        cell.textField.text = ""
        
        cell.textField.text = user?[key] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
}
