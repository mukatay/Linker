//
//  Settings.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/21/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    
    @IBAction func logOutTapped(sender: UIBarButtonItem) {
        PFFacebookUtils.unlinkUserInBackground(PFUser.currentUser()!)
        PFUser.logOut()

    }
}
