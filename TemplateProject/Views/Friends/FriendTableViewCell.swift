//
//  FriendTableViewCell.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/22/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendPicture: UIImageView!
    
    @IBOutlet weak var friendUsername: UILabel!
    
    var isChecked = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
