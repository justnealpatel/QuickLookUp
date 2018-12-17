//
//  SignInViewController.swift
//  QuickLookUp
//
//  Created by Neal Patel on 11/24/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit
import CoreData

class SignInViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Quick Look Up!"
        label.font = UIFont(name: "Futura", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Colors.textBlue
        return label
    }()
    
    var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "QuickLookUpLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var fieldsRequiredLabel: UIUnderlinedLabel = {
        let label = UIUnderlinedLabel()
        label.text = "All fields are required*"
        label.font = UIFont(name: "Futura", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Colors.textBlue
        return label
    }()
    
    var associatedEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email associated with your account:"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textBlue
        return label
    }()
    
    var emailTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.textColor = Colors.textBlue
        return textField
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textBlue
        return label
    }()
    
    var passwordTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.layer.borderWidth = 1
        textField.textColor = Colors.textBlue
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.lightBlue
        button.setTitleColor(Colors.textBlue, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.textBlue.cgColor
        button.sizeToFit()
        return button
    }()
    
    @objc func login() {
        if !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! {
            if isValidEmail(email: emailTextField.text!) {
                let updatedDeviceToken = appDelegate?.deviceToken
                let email = emailTextField.text!
                let passwordDigest = MD5(string: passwordTextField.text!)
                let serverurl = "http://ec2-54-89-95-237.compute-1.amazonaws.com/getAccount.php"
                let requestURL = NSURL(string: serverurl)
                // Creating NSMutableURLRequest
                let request = NSMutableURLRequest(url: requestURL! as URL)
                // Setting the method to post
                request.httpMethod = "POST"
                // Creating the post parameter by concatenating the keys and values from text field
                let postParameters = "email=" + email + "&pass_word=" + passwordDigest + "&deviceID=" + String(updatedDeviceToken!);
                // Adding the parameters to request body
                request.httpBody = postParameters.data(using: String.Encoding.utf8)
                // Creating a task to send the post request
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    if error != nil {
                        print("error=\(String(describing: error))")
                        return
                    }
                    print("response = \(String(describing: response))")
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(String(describing: responseString))")
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let dictionary = json as? [String: Any] {
                        if let error = dictionary["error"] as? Bool {
                            if !error {
                                if let accountID = dictionary["accountID"] as? Int {
                                    UserDefaults.standard.set(accountID, forKey: "accountID")
                                    let accts = fetchAccount(accountID: Int16(accountID))
                                    if let account = accts {
                                        let account = NSEntityDescription.insertNewObject(forEntityName: "Account", into: PersistenceService.context) as! Account
                                        account.id = Int16(accountID)
                                        PersistenceService.saveContext()
                                    } else {
                                        print("account already in core data")
                                    }
                                }
                                if let firstName = dictionary["firstName"] as? String {
                                    UserDefaults.standard.set(firstName, forKey: "firstName")
                                }
                                if let lastName = dictionary["lastName"] as? String {
                                    UserDefaults.standard.set(lastName, forKey: "lastName")
                                }
                                DispatchQueue.main.async {
                                    let layout = UICollectionViewFlowLayout()
                                    let homePageVC = UINavigationController(rootViewController: HomePageCollectionViewController(collectionViewLayout: layout))
                                    homePageVC.transitioningDelegate = self
                                    globalMessages = []
                                    globalItems = []
                                    self.navigationController!.present(homePageVC, animated: true)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Incorrect Email or Password", message: "We could not find an account associated with your email or password. Please try again.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                    self.present(alert, animated: true)
                                }
                            }
                        }
                    }
                }
                task.resume()
            } else {
                createErrorAlert(title: "Invalid Email", message: "Please make sure your email is in the proper format", viewController: self)
            }
        } else {
            createErrorAlert(title: "Please Fill In All Fields", message: "In order to login, please fill in all required fields.", viewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = Colors.lightBlue
        appDelegate?.registerForPushNotifications(application: UIApplication.shared)
        view.setNeedsUpdateConstraints()
        view.backgroundColor = Colors.lightBlue
        view.addSubview(welcomeLabel)
        view.addSubview(logoImageView)
        view.addSubview(fieldsRequiredLabel)
        view.addSubview(associatedEmailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        self.hideKeyboardWhenTappedOutside()
        
        [welcomeLabel.widthAnchor.constraint(equalToConstant: 310),
         welcomeLabel.heightAnchor.constraint(equalToConstant: 40),
         welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [logoImageView.widthAnchor.constraint(equalToConstant: 310),
         logoImageView.heightAnchor.constraint(equalToConstant: 190), logoImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
         logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [fieldsRequiredLabel.widthAnchor.constraint(equalToConstant: 170),
         fieldsRequiredLabel.heightAnchor.constraint(equalToConstant: 30),
         fieldsRequiredLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40), fieldsRequiredLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27)].forEach{ $0.isActive = true }
        
        [associatedEmailLabel.widthAnchor.constraint(equalToConstant: 310),
         associatedEmailLabel.heightAnchor.constraint(equalToConstant: 40),
         associatedEmailLabel.topAnchor.constraint(equalTo: fieldsRequiredLabel.bottomAnchor, constant: 0), associatedEmailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27)].forEach{ $0.isActive = true }
        
        [emailTextField.widthAnchor.constraint(equalToConstant: 290),
         emailTextField.heightAnchor.constraint(equalToConstant: 40),
         emailTextField.topAnchor.constraint(equalTo: associatedEmailLabel.bottomAnchor, constant: 5), emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27)].forEach{ $0.isActive = true }
        
        [passwordLabel.widthAnchor.constraint(equalToConstant: 310),
         passwordLabel.heightAnchor.constraint(equalToConstant: 40),
         passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5), passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27)].forEach{ $0.isActive = true }
        
        [passwordTextField.widthAnchor.constraint(equalToConstant: 290),
         passwordTextField.heightAnchor.constraint(equalToConstant: 40),
         passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5), passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27)].forEach{ $0.isActive = true }
        
        [loginButton.widthAnchor.constraint(equalToConstant: 110),
         loginButton.heightAnchor.constraint(equalToConstant: 50), loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40), loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
}
