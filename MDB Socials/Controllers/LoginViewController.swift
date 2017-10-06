//
//  ViewController.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var appTitle: UILabel!
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    var loginButton: UIButton!
    var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle() //title of app
        setupTextFields() //email and password text fields for login
        setupButtons() //login and signup buttons
        
        //Checks if a user is already signed in, then the app automatically goes to the FeedVC
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "toFeedFromLogin", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupTitle() {
        appTitle = UILabel(frame: CGRect(x: view.frame.width * 0.5 - 150, y: 10, width: 300, height: 0.4 * UIScreen.main.bounds.height))
        appTitle.font = UIFont(name: "AvenirNext-Regular", size: 45)
        appTitle.textAlignment = .center
        appTitle.text = "MDB Socials"
        view.addSubview(appTitle)
    }
    
    func setupTextFields() {
        emailTextField = UITextField(frame: CGRect(x: UIScreen.main.bounds.width * 0.15, y: 0.4 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width * 0.7, height: 50))
        emailTextField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        emailTextField.placeholder = "    Email"
        emailTextField.layoutIfNeeded()
        emailTextField.textColor = UIColor.black
        emailTextField.setBottomBorder()
        self.view.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: UIScreen.main.bounds.width * 0.15, y: emailTextField.frame.maxY + 10, width: UIScreen.main.bounds.width * 0.7, height: 50))
        emailTextField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        passwordTextField.placeholder = "    Password"
        passwordTextField.textColor = UIColor.black
        passwordTextField.setBottomBorder()
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
    }
    
    func setupButtons() {
        loginButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.15 - 5, y: passwordTextField.frame.maxY + 20, width: 0.35 * UIScreen.main.bounds.width, height: 60))
        loginButton.layoutIfNeeded()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = Constants.blueBackgroundColor
        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        signupButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.5 + 5, y: passwordTextField.frame.maxY + 20, width: 0.35 * UIScreen.main.bounds.width , height: 60))
        signupButton.layoutIfNeeded()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.backgroundColor = Constants.blueBackgroundColor
        signupButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        signupButton.layer.cornerRadius = 8.0
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: #selector(signupButtonClicked), for: .touchUpInside)
        self.view.addSubview(signupButton)
    }
    
    @objc func loginButtonClicked(sender: UIButton!) {
        let email = emailTextField.text!
        emailTextField.text = ""
        let password = passwordTextField.text!
        passwordTextField.text = ""
        Auth.auth().signIn(withEmail: email, password: password, completion: { (User, error) in
            if error == nil {
                self.performSegue(withIdentifier: "toFeedFromLogin", sender: self)
            }
            else {
                self.showToast(message: "User not found. Please try again or sign up.")
            }
        })
    }
    
    @objc func signupButtonClicked(sender: UIButton!) {
        performSegue(withIdentifier: "toSignup", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIViewController {
    
    func showToast(message : String) { //show temporary popup for error message: from stack overflow #31540375
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width*0.15, y: self.view.frame.size.height * 0.8, width: self.view.frame.width * 0.7, height: 70))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.numberOfLines = 2
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
