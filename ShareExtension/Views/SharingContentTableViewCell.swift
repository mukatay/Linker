//
//  SharingContentTableViewCell.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/28/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class SharingContentTableViewCell: UITableViewCell {

    @IBOutlet weak var linkTitle: UILabel!
    
    @IBOutlet weak var linkImage: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}