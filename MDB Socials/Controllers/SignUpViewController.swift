//
//  SignUpViewController.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    var emailTextField: UITextField! //text field for email
    var passwordTextField: UITextField! //text field for passwrd
    var nameTextField: UITextField! //text field for full name
    
    var signupButton: UIButton!
    
    var goBackButton: UIButton! //go back to login view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTextFields() //create text fields for user to enter data
        setupButtons() //create back button and sign up button
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) //dismisses the keyboard
        super.touchesBegan(touches, with: event)
    }
    
    func setupTextFields() {
        nameTextField = UITextField(frame: CGRect(x: UIScreen.main.bounds.width * 0.15, y: 0.30 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width * 0.7, height: 50))
        nameTextField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        nameTextField.placeholder = "    Full Name"
        nameTextField.layoutIfNeeded()
        nameTextField.setBottomBorder()
        nameTextField.textColor = UIColor.black
        
        self.view.addSubview(nameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: UIScreen.main.bounds.width * 0.15, y: nameTextField.frame.maxY + 10, width: UIScreen.main.bounds.width * 0.7, height: 50))
        emailTextField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        emailTextField.placeholder = "    Email"
        emailTextField.layoutIfNeeded()
        emailTextField.textColor = UIColor.black
        emailTextField.setBottomBorder()
        self.view.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: UIScreen.main.bounds.width * 0.15, y: emailTextField.frame.maxY + 10, width: UIScreen.main.bounds.width * 0.7, height: 50))
        passwordTextField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        passwordTextField.placeholder = "    Password"
        passwordTextField.textColor = UIColor.black
        passwordTextField.setBottomBorder()
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
    }
    
    func setupButtons() {
        goBackButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.15 - 5, y: passwordTextField.frame.maxY + 25, width: 0.35 * UIScreen.main.bounds.width , height: 60))
        MDBSocialsUtils.defineButtonAttributes(button: goBackButton)
        goBackButton.setTitle("Go Back", for: .normal)
        goBackButton.addTarget(self, action: #selector(goBackButtonClicked), for: .touchUpInside)
        self.view.addSubview(goBackButton)
        
        signupButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.5 + 5, y: passwordTextField.frame.maxY + 25, width: 0.35 * UIScreen.main.bounds.width , height: 60))
        MDBSocialsUtils.defineButtonAttributes(button: signupButton)
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.addTarget(self, action: #selector(signupButtonClicked), for: .touchUpInside)
        self.view.addSubview(signupButton)
        
    }
    
    
    @objc func signupButtonClicked() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (User, error) in
            if error == nil {
                let ref = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
                ref.setValue(["name": name, "email": email])
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.nameTextField.text = ""
                self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
            }
            else {
                self.showToast(message: "Error creating user.")
            }
        })
    }
    
    @objc func goBackButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UITextField { //for bottom text line: from stack overflow #26800963
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
