//
//  User.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var id: String! // unique id generated
    var name: String! // full name
    var email: String!
    
    init(id: String, userDict: [String:Any]) {
        self.id = id
        if userDict != nil {
            if let name = userDict["name"] as? String {
                self.name = name
            }
            else {
                self.name = "John Doe"
            }
            if let email = userDict["email"] as? String {
                self.email = email
            }
            else {
                self.email = "johndoe@gmail.com"
            }
        }
    }
    
    
}
