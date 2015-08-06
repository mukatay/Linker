//
//  AboutTableViewCell.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 8/5/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableText: UILabel!
    
    @IBOutlet weak var versionText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
