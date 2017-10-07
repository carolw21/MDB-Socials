//
//  Post.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Event {
    
    var id: String! //unique id for event
    var title: String! //name of event
    var date: String! //date of event
    var member: String! //member who posted event
    var rsvpCount: Int! //how many people rsvp'ed to event
    var descriptionText: String! //short description of event
    var rsvpArray: [String]!
    var image: UIImage!
    var imageUrl: String!
    
    init(id: String, eventDict: [String:Any]) {
        self.id = id
        if let title = eventDict["title"] as? String {
            self.title = title
        }
        else {
            self.title = "Placeholder title."
        }
        if let date = eventDict["date"] as? String {
            self.date = date
        }
        else {
            self.date = "9/09/1999 at 9:09 am"
        }
        if let member = eventDict["member"] as? String {
            self.member = member
        }
        else {
            self.member = "Member name."
        }
        if let imageUrl = eventDict["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        else {
            self.imageUrl = ""
        }
        if let rsvpCount = eventDict["rsvpCount"] as? Int {
            self.rsvpCount = rsvpCount
        }
        else {
            self.rsvpCount = 0
        }
        if let descriptionText = eventDict["descriptionText"] as? String {
            self.descriptionText = descriptionText
        }
        else {
            self.descriptionText = "This is a description placeholder."
        }
        if let rsvpArray = eventDict["rsvpArray"] as? [String]! {
            self.rsvpArray = rsvpArray
        }
        else {
            self.rsvpArray = []
        }
    }
    
    func getEventImage(withBlock: @escaping () -> ()) {
        do {
            try self.image = UIImage(data: Data(contentsOf: URL(string: self.imageUrl)!))
        } catch {
            self.image = #imageLiteral(resourceName: "skydiving")
        }
        withBlock()
    }
    
    func addInterestedUser() {
        let interested = self.rsvpArray.contains((FeedViewController.currentUser?.name)!)
        if !interested {
            self.rsvpCount! += 1
            self.rsvpArray.append((FeedViewController.currentUser?.name)!)
        }
        else {
            self.rsvpCount! -= 1
           self.rsvpArray.remove(at: self.rsvpArray.index(of: (FeedViewController.currentUser.name)!)!)
        }
        //upload changes to firebase
        Database.database().reference().child("Events").child(self.id).updateChildValues(["rsvpCount": self.rsvpCount!, "rsvpArray": self.rsvpArray])
       
        FeedViewController.eventCollectionView.reloadData()
    }
    
}
