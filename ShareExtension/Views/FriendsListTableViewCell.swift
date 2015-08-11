//
//  FriendListTableViewCell.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/23/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {

    @IBOutlet weak var friendListPicture: UIImageView!

    @IBOutlet weak var friendListUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
