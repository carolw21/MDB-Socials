//
//  PostCollectionViewCell.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    var eventImage: UIImageView! //image for event
    var eventTitle: UILabel! //name of event
    var rsvpText: UILabel! //how many people rsvp'ed to event
    var memberName: UILabel! //member who posted event
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        setupEventImage()
        setupEventText()
        setupMemberText()
        setupRsvpText()
    }
    
    func setupEventImage() {
        eventImage = UIImageView(frame: CGRect(x: 10, y: 0.15 * self.frame.height, width: 0.70 * self.frame.height, height: 0.70 * self.frame.height))
        eventImage.contentMode = .scaleAspectFit
        eventImage.layer.cornerRadius = 8.0
        eventImage.clipsToBounds = true
        addSubview(eventImage)
    }
    
    func setupEventText() {
        eventTitle = UILabel(frame: CGRect(x: eventImage.frame.maxX + 20, y: 0.15 * self.frame.height, width: self.frame.width * 0.8, height: 30))
        eventTitle.textColor = UIColor.black
        eventTitle.font = UIFont(name: "AvenirNext-Regular", size: 24)
        addSubview(eventTitle)
    }
    
    func setupMemberText() {
        memberName = UILabel(frame: CGRect(x: eventImage.frame.maxX + 20, y: eventTitle.frame.maxY + 10, width: self.frame.width * 0.5, height: 30))
        memberName.font = UIFont(name: "AvenirNext-Regular", size: 18)
        memberName.textColor = UIColor.black
        addSubview(memberName)
    }

    func setupRsvpText() {
        rsvpText = UILabel(frame: CGRect(x: eventImage.frame.maxX + 20, y: memberName.frame.maxY + 8, width: self.frame.width, height: 30))
        rsvpText.textColor = UIColor.black
        rsvpText.font = UIFont(name: "AvenirNext-Regular", size: 18)
        rsvpText.adjustsFontForContentSizeCategory = true
        addSubview(rsvpText)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventImage.isHidden = true
        eventTitle.isHidden = true
        memberName.isHidden = true
        rsvpText.isHidden = true
    }
    
}
