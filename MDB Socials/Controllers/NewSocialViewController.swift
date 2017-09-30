//
//  AddEventViewController.swift
//  MDB Socials
//
//  Created by Carol Wang on 9/27/17.
//  Copyright © 2017 MDB. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class NewSocialViewController: UIViewController, UITextViewDelegate {

    var goBackButton: UIButton!
    var addButton: UIButton!
    
    var eventImage: UIImageView! //image user has to set
    var newImageButton: UIButton! //button to set the image
    
    var nameTextField: UITextField!
    
    var datePicker = UIDatePicker()
    var textDatePicker: UITextField!
    
    var descriptionTextView : UITextView!
    var placeholderLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = UIColor(red: 0, green: 157/255, blue: 1, alpha: 0.5)
        
        setupBackButton()
        setupImageView()
        setupTextField()
        setupDatePicker()
        setupTextView()
        setupAddButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBackButton() {
        goBackButton = UIButton(frame: CGRect(x: 10, y: 25, width: 0.35 * UIScreen.main.bounds.width , height: 60))
        goBackButton.layoutIfNeeded()
        goBackButton.setTitle("Go Back", for: .normal)
        goBackButton.setTitleColor(.white, for: .normal)
        goBackButton.backgroundColor = UIColor(red: 0, green: 157/255, blue: 1, alpha: 0.9)
        goBackButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        goBackButton.layer.cornerRadius = 8.0
        goBackButton.layer.masksToBounds = true
        goBackButton.addTarget(self, action: #selector(goBackButtonClicked), for: .touchUpInside)
        self.view.addSubview(goBackButton)
    }
    
    func setupImageView() {
        eventImage = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width * 0.5 - 150, y: 0.20 * UIScreen.main.bounds.height, width: 130, height: 130))
        eventImage.image = #imageLiteral(resourceName: "plus.png")
        eventImage.contentMode = .scaleAspectFit
        eventImage.layer.cornerRadius = 8.0
        eventImage.clipsToBounds = true
        self.view.addSubview(eventImage)
        
        newImageButton = UIButton(frame: CGRect(x: 0.37 * self.view.frame.width - 83, y: eventImage.frame.maxY + 6, width: 0.26 * UIScreen.main.bounds.width , height: 40))
        newImageButton.layoutIfNeeded()
        newImageButton.setTitle("Set Image", for: .normal)
        newImageButton.setTitleColor(.white, for: .normal)
        newImageButton.backgroundColor = UIColor(red: 0, green: 157/255, blue: 1, alpha: 0.9)
        newImageButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        newImageButton.layer.cornerRadius = 8.0
        newImageButton.layer.masksToBounds = true
        newImageButton.addTarget(self, action: #selector(setImageButtonClicked), for: .touchUpInside)
        self.view.addSubview(newImageButton)
        
        self.imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    func setupTextField() {
        nameTextField = UITextField(frame: CGRect(x: UIScreen.main.bounds.width * 0.5 + 8, y: 0.20 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width * 0.4, height: 50))
        nameTextField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        nameTextField.placeholder = " Name of event"
        nameTextField.layoutIfNeeded()
        nameTextField.setBottomBorder()
        nameTextField.textColor = UIColor.black
        self.view.addSubview(nameTextField)
    }
    
    func setupDatePicker() {
        textDatePicker = UITextField(frame: CGRect(x: UIScreen.main.bounds.width * 0.5 + 8, y: nameTextField.frame.maxY + 10, width: UIScreen.main.bounds.width * 0.4, height: 60))
        textDatePicker.font = UIFont(name: "AvenirNext-Regular", size: 16)
        textDatePicker.placeholder = " Select date and time"
        textDatePicker.layoutIfNeeded()
        textDatePicker.setBottomBorder()
        textDatePicker.textColor = UIColor.black
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: .valueChanged)
        
        // add toolbar to textField
        // add datepicker to textField
        textDatePicker.inputView = datePicker
        
        view.addSubview(textDatePicker)
    }
    
    @objc func datePickerChanged() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yy' 'h:mm a"
        
        let strDate = dateFormatter.string(from: datePicker.date)
        
        textDatePicker.text = strDate
    }
    
    func setupTextView() {
        descriptionTextView = UITextView(frame: CGRect(x: view.frame.width * 0.1, y: view.frame.height * 0.7, width: view.frame.width * 0.8, height: 80.0))
        descriptionTextView.center = CGPoint(x: self.view.center.x, y: self.view.center.y+20)
        descriptionTextView.textAlignment = .left
        descriptionTextView.font = UIFont(name: "AvenirNext-Regular", size: 18)
        descriptionTextView.layer.cornerRadius = 10.0
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.textColor = UIColor.black
        
        descriptionTextView.delegate = self
        placeholderLabel = UILabel(frame: CGRect(x: 3, y: 5, width: view.frame.width * 0.7, height: 70.0))
        placeholderLabel.text = "  Brief description of event..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
        placeholderLabel.sizeToFit()
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.numberOfLines = 2
        descriptionTextView.addSubview(placeholderLabel)
        
        self.view.addSubview(descriptionTextView)
    }

    //if user starts typing in textView
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func setupAddButton() {
        addButton = UIButton(frame: CGRect(x: 0.30 * UIScreen.main.bounds.width, y: descriptionTextView.frame.maxY + 40, width: 0.40 * UIScreen.main.bounds.width , height: 60))
        addButton.layoutIfNeeded()
        addButton.setTitle("Add event", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor(red: 0, green: 157/255, blue: 1, alpha: 0.9)
        addButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        addButton.layer.cornerRadius = 8.0
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        self.view.addSubview(addButton)
    }
    
    @objc func setImageButtonClicked() {
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
                                                       message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                self.imagePicker.sourceType = .camera
                                                self.imagePicker.allowsEditing = false
                                                self.present(self.imagePicker,
                                                                           animated: true,
                                                                           completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(title: "Choose Existing",
                                          style: .default) { (alert) -> Void in
                                            self.imagePicker.allowsEditing = true
                                            self.imagePicker.sourceType = .photoLibrary
                                            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                                            self.present(self.imagePicker, animated: true, completion: {print(true)})
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        
        present(imagePickerActionSheet, animated: true,
                              completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func goBackButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonClicked() -> Void{
        if let img = eventImage.image {
            let imageData = UIImageJPEGRepresentation(img, 0.9)
            let key = Database.database().reference().childByAutoId().key
            let storage = Storage.storage().reference().child("EventPics/\(FeedViewController.currentUser.id)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storage.putData(imageData!, metadata: metadata).observe(.success) { (snapshot) in
                let event = ["title": self.nameTextField.text!, "imageUrl": FeedViewController.currentUser.id, "member": FeedViewController.currentUser.name!,
                             "rsvpCount": 1, "rsvpArray": [FeedViewController.currentUser.name!], "descriptionText": self.descriptionTextView.text!, "date": self.textDatePicker.text!] as [String : Any]
                let childUpdates = ["/Events/\(key)": event]
                Database.database().reference().updateChildValues(childUpdates)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else {
            showToast(message: "Please choose valid image.")
        }
    }
}

extension NewSocialViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        eventImage.contentMode = .scaleAspectFit
        eventImage.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
