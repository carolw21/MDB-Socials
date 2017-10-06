//
//  DetailViewController.swift
//  MDB Socials
//
//  Created by Carol Wang on 9/29/17.
//  Copyright © 2017 MDB. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {

    var event: Event!
    
    var goBackButton: UIButton!
    var eventImage: UIImageView!
    var eventTitle: UILabel!
    var eventDate: UILabel!
    var memberName: UILabel!
    var descriptionText: UILabel!
    var rsvpText: UILabel!
    var interestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackButton()
        setupEventImage()
        setupEventText()
        setupDateText()
        setupMemberText()
        setupDescriptionText()
        setupRsvpText()
        setupInterestedButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBackButton() {
        goBackButton = UIButton(frame: CGRect(x: 10, y: 25, width: 0.35 * view.frame.width , height: 60))
        MDBSocialsUtils.defineButtonAttributes(button: goBackButton)
        goBackButton.setTitle("Go Back", for: .normal)
        goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.view.addSubview(goBackButton)
    }
    
    func setupEventImage() {
        eventImage = UIImageView(frame: CGRect(x: 10, y: goBackButton.frame.maxY + 20, width: 150, height: 150))
        eventImage.contentMode = .scaleAspectFit
        eventImage.layer.cornerRadius = 8.0
        eventImage.clipsToBounds = true
        eventImage.image = event.image!
        view.addSubview(eventImage)
    }
    
    func setupEventText() {
        eventTitle = UILabel(frame: CGRect(x: eventImage.frame.maxX + 12, y: eventImage.frame.minY + 20, width: view.frame.width * 0.7, height: 30))
        eventTitle.textColor = UIColor.black
        eventTitle.font = UIFont(name: "AvenirNext-Regular", size: 23)
        eventTitle.text = event.title!
        view.addSubview(eventTitle)
    }
    
    func setupDateText() {
        eventDate = UILabel(frame: CGRect(x: eventImage.frame.maxX + 10, y: eventTitle.frame.maxY + 5, width: view.frame.width * 0.7, height: 30))
        eventDate.textColor = UIColor.black
        eventDate.font = UIFont(name: "AvenirNext-Regular", size: 18)
        eventDate.text = event.date!
        view.addSubview(eventDate)
    }
    
    func setupMemberText() {
        memberName = UILabel(frame: CGRect(x: eventImage.frame.maxX + 10, y: eventDate.frame.maxY + 5, width: view.frame.width * 0.5, height: 30))
        memberName.font = UIFont(name: "AvenirNext-Regular", size: 18)
        memberName.textColor = UIColor.black
        memberName.text = "by " + event.member!
        view.addSubview(memberName)
    }
    
    func setupDescriptionText() {
        descriptionText = UILabel(frame: CGRect(x: 10, y: eventImage.frame.maxY + 5, width: view.frame.width * 0.9, height: 60))
        descriptionText.font = UIFont(name: "AvenirNext-Regular", size: 18)
        descriptionText.textColor = UIColor.black
        descriptionText.numberOfLines = 2
        descriptionText.lineBreakMode = .byWordWrapping
        descriptionText.text = event.descriptionText!
        view.addSubview(descriptionText)
    }
    
    func setupRsvpText() {
        rsvpText = UILabel(frame: CGRect(x: eventImage.frame.minX + 25, y: descriptionText.frame.maxY + 35, width: view.frame.width * 0.3, height: 30))
        rsvpText.textColor = UIColor.black
        rsvpText.font = UIFont(name: "AvenirNext-Regular", size: 18)
        rsvpText.adjustsFontForContentSizeCategory = true
        rsvpText.text = "\(event.rsvpCount!) interested"
        view.addSubview(rsvpText)
    }
    
    func setupInterestedButton() {
        interestButton = UIButton(frame: CGRect(x: eventImage.frame.maxX + 8, y: descriptionText.frame.maxY + 20, width: 0.40 * UIScreen.main.bounds.width , height: 60))
        MDBSocialsUtils.defineButtonAttributes(button: interestButton)
        let index = FeedViewController.events.index(where: { $0.id == event.id })
        let interested = FeedViewController.events[index!].rsvpArray.contains(FeedViewController.currentUser.name)
        if !interested {
            interestButton.setTitle("Mark interested", for: .normal)
        }
        else{
            interestButton.setTitle("Interested", for: .normal)
        }
        interestButton.addTarget(self, action: #selector(interestButtonClicked), for: .touchUpInside)
        view.addSubview(interestButton)
    }
    
    @objc func interestButtonClicked() {
        let index = FeedViewController.events.index(where: { $0.id == event.id })
        FeedViewController.events[index!].addInterestedUser()
        rsvpText.text = "Interested: \(FeedViewController.events[index!].rsvpCount!)"
        if FeedViewController.events[index!].rsvpArray.contains(FeedViewController.currentUser.id) {
            interestButton.setTitle("Interested", for: .normal)
        }
        else {
            interestButton.setTitle("Mark Interested", for: .normal)
        }
    }

    @objc func goBack() {
         dismiss(animated:true, completion: nil)
    }
    
}
