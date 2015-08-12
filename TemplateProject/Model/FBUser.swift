//
//  FBUser.swift
//  TemplateProject
//
//  Created by Darkhan Mukatay on 7/23/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation

class FBUser {
    var username: String
    var fbId : String
    var profilePic: String?
    
    init(username: String, fbId: String, profilePic: String?) {
        self.username = username
        self.fbId = fbId
        self.profilePic = profilePic
    }
    
    init(data: [String: String?]) {
        self.username = data["username"]!!
        self.fbId = data["fbId"]!!
        self.profilePic = data["profilePic"]!
    }
    
    func toJson() -> [String: String?] {
        return [
            "username": username,
            "fbId": fbId,
            "profilePic": profilePic,
        ]
    }
}