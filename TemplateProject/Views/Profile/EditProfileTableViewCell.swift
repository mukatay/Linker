//
//  EditProfileTableViewCell.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/20/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class EditProfileTableViewCell: UITableViewCell {
    
    @IBAction func valueChanged(sender: AnyObject) {
        PFUser.currentUser()?[key] = textField.text
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    var key = "" {
        didSet {
            titleLabel.text = key
        }
    }
    
}
