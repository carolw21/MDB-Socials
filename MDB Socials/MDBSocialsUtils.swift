//
//  MDBSocialsUtils.swift
//  MDB Socials
//
//  Created by Carol Wang on 10/5/17.
//  Copyright © 2017 MDB. All rights reserved.
//

import UIKit

class MDBSocialsUtils{
    
    static func defineButtonAttributes(button: UIButton) {
        button.layoutIfNeeded()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.blueBackgroundColor
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
    }
    
}
