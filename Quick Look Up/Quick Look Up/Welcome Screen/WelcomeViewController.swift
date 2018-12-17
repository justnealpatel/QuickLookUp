//
//  WelcomeViewController.swift
//  QuickLookUp
//
//  Created by Neal Patel on 11/24/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Quick Look Up!"
        label.font = UIFont(name: "Futura", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red:0.039, green:0.027, blue:0.620, alpha:1.000)
        return label
    }()
    
    var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "QuickLookUpLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.lightBlue
        button.setTitleColor(Colors.textBlue, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.textBlue.cgColor
        return button
    }()
    
    var newUserButton: UIButton = {
        let button = UIButton()
        button.setTitle("New User", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.lightBlue
        button.setTitleColor(Colors.textBlue, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.textBlue.cgColor
        return button
    }()
    
    // Called when the Sign In button is pressed
    @objc func signIn() {
        let signInVC = SignInViewController()
        signInVC.transitioningDelegate = self
        self.navigationController!.pushViewController(signInVC, animated: true)
    }
    
    // Called when the New User button is pressed
    @objc func newUser() {
        let newAccountVC = NewAccountViewController()
        newAccountVC.transitioningDelegate = self
        self.navigationController!.pushViewController(newAccountVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // What gets called as soon as the screen is shown
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = Colors.lightBlue
        view.backgroundColor = UIColor(red:0.820, green:0.933, blue:1.000, alpha:1.000)
        view.setNeedsUpdateConstraints()
        view.addSubview(welcomeLabel)
        view.addSubview(logoImageView)
        view.addSubview(signInButton)
        view.addSubview(newUserButton)
        
        [welcomeLabel.widthAnchor.constraint(equalToConstant: 310),
         welcomeLabel.heightAnchor.constraint(equalToConstant: 40),
         welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [logoImageView.widthAnchor.constraint(equalToConstant: 310),
         logoImageView.heightAnchor.constraint(equalToConstant: 190), logoImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
         logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [signInButton.widthAnchor.constraint(equalToConstant: 120),
         signInButton.heightAnchor.constraint(equalToConstant: 60),
         signInButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
         signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        [newUserButton.widthAnchor.constraint(equalToConstant: 120),
         newUserButton.heightAnchor.constraint(equalToConstant: 60),
         newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 40),
         newUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        newUserButton.addTarget(self, action: #selector(newUser), for: .touchUpInside)
    }
}
