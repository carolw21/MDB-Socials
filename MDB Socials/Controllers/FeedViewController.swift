//
//  FeedViewController.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    var newEventButton: UIButton!
    static var eventCollectionView: UICollectionView!
    static var events: [Event] = []
    var eventToPass: Event!
    
    var auth = Auth.auth()
    var eventsRef: DatabaseReference = Database.database().reference().child("events")
    var storage: StorageReference = Storage.storage().reference()
    static var currentUser: User!
    var navBar: UINavigationBar!
    
    var itemCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser {
            self.setupNavBar()
            self.setupButton()
            self.setupCollectionView()
            self.fetchEvents() {
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY, width: view.frame.width, height: view.frame.height * 0.06))
        navBar.backgroundColor = UIColor.clear
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: "Feed");
        
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        logOutButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 20)!], for: .normal)
        navItem.rightBarButtonItem = logOutButton
        navBar.setItems([navItem], animated: false)
        navBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 20)!]
        self.view.addSubview(navBar)
    }
    
    @objc func logOut() {
        //TODO: Log out using Firebase!
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "toLogin", sender: self)
        } catch _ as NSError {
            self.showToast(message: "Error logging out.")
        }
    }

    func setupButton() {
        newEventButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.15, y: navBar.frame.maxY + 16, width: 0.75 * UIScreen.main.bounds.width , height: 60))
        MDBSocialsUtils.defineButtonAttributes(button: newEventButton)
        newEventButton.setTitle("Add new event", for: .normal)
        newEventButton.addTarget(self, action: #selector(goToAddEvent), for: .touchUpInside)
        self.view.addSubview(newEventButton)
    }
    
    
    func setupCollectionView() {
        
        let frame = CGRect(x: 10, y: newEventButton.frame.maxY + 5, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - newEventButton.frame.maxY - 20)
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.minimumLineSpacing = 0
        cvLayout.minimumInteritemSpacing = 0
        FeedViewController.eventCollectionView = UICollectionView(frame: frame, collectionViewLayout: cvLayout)
        FeedViewController.eventCollectionView.delegate = self
        FeedViewController.eventCollectionView.dataSource = self
        FeedViewController.eventCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: "event")
        FeedViewController.eventCollectionView.backgroundColor = UIColor.white
        view.addSubview(FeedViewController.eventCollectionView)
    }
    
    @objc func goToAddEvent() {
        self.performSegue(withIdentifier: "toAddEvent", sender: self)
    }
    
    func fetchEvents(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch events with Firebase!
        let ref = Database.database().reference()
        
        ref.child("Events").observe(.childAdded, with: { (snapshot) in
            let event = Event(id: snapshot.key, eventDict: (snapshot.value! as? [String : Any])!)
            if !FeedViewController.events.contains(where: {$0.id == event.id}) {
                FeedViewController.events.append(event)
            }
            FeedViewController.eventCollectionView.reloadData()
        })
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch events with Firebase!
        let ref = Database.database().reference()
        ref.child("Users").child((self.auth.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(id: snapshot.key, userDict: (snapshot.value! as? [String : Any])!)
            FeedViewController.currentUser = user
            withBlock()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.event = eventToPass
        }
    }
    
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeedViewController.events.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FeedViewController.eventCollectionView.dequeueReusableCell(withReuseIdentifier: "event", for: indexPath) as! EventCollectionViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        let eventInQuestion = FeedViewController.events[FeedViewController.events.count - indexPath.row - 1]
        cell.eventTitle.text = eventInQuestion.title!
        cell.memberName.text = "By: \(eventInQuestion.member!)"
        cell.rsvpText.text = "\(eventInQuestion.rsvpCount!) interested"
        
        eventInQuestion.getEventImage(withBlock: {
            cell.eventImage.image = eventInQuestion.image
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventToPass = FeedViewController.events[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    
}

