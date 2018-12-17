//
//  NewAccountViewController.swift
//  QuickLookUp
//
//  Created by Neal Patel on 11/24/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit
import CoreData

class NewAccountViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var firstNameTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.textColor = Colors.textBlue
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .sentences
        return textField
    }()
    
    var lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var lastNameTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.textColor = Colors.textBlue
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .sentences
        return textField
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var emailTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.textColor = Colors.textBlue
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .sentences
        return textField
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var passwordTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.textColor = Colors.textBlue
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .sentences
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var reenterPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Re-enter Password*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var reenterPasswordTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.textColor = Colors.textBlue
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .sentences
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.lightBlue
        button.setTitleColor(Colors.textBlue, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.borderColor = Colors.textBlue.cgColor
        button.layer.borderWidth = 1
        button.sizeToFit()
        return button
    }()
    
    @objc func createAccount() {
        if !(firstNameTextField.text?.isEmpty)! && !(lastNameTextField.text?.isEmpty)! && !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! && !(reenterPasswordTextField.text?.isEmpty)! {
            if isValidEmail(email: emailTextField.text!) {
                let serverurl = "http://ec2-54-89-95-237.compute-1.amazonaws.com/storeAccount.php"
                let requestURL = NSURL(string: serverurl)
                // Creating NSMutableURLRequest
                let request = NSMutableURLRequest(url: requestURL! as URL)
                // Setting the method to post
                request.httpMethod = "POST"
                let firstName = firstNameTextField.text!
                let lastName = lastNameTextField.text!
                let email = emailTextField.text!
                let passwordDigest = MD5(string: self.passwordTextField.text!)
                let updatedDeviceToken = appDelegate?.deviceToken
                let postParameters = "firstName=" + firstName + "&lastName=" + lastName + "&email=" + email + "&pass_word=" + passwordDigest + "&deviceID=" + String(updatedDeviceToken!);
                // Adding the parameters to request body
                request.httpBody = postParameters.data(using: String.Encoding.utf8)
                // Creating a task to send the post request
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    if error != nil {
                        print("error=\(String(describing: error))")
                        return
                    }
                    print("\(String(describing: response))")
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let dictionary = json as? [String: Any] {
                        if let error = dictionary["error"] as? Bool {
                            if !error {
                                print("No error!")
                                // Get account id
                                if let accountID = dictionary["accountID"] as? Int {
                                    print("Account created")
                                    UserDefaults.standard.set(accountID, forKey: "accountID")
                                    UserDefaults.standard.set(firstName, forKey: "firstName")
                                    UserDefaults.standard.set(lastName, forKey: "lastName")
                                    let account = NSEntityDescription.insertNewObject(forEntityName: "Account", into: PersistenceService.context) as! Account
                                    account.id = Int16(accountID)
                                    PersistenceService.saveContext()
                                    let acct = fetchAccount(accountID: Int16(accountID))
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Success!", message: "We've successfully created your account. Would you like to report a lost or missing item?", preferredStyle: .alert)
                                        let reportAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                                            print("let's report an item now")
                                            globalMessages = []
                                            globalItems = []
                                            let categoryPickerVC = CategoryPickerViewController()
                                            categoryPickerVC.transitioningDelegate = self
                                            self.navigationController!.present(categoryPickerVC, animated: true)
                                        })
                                        let noReportAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                                            globalMessages = []
                                            globalItems = []
                                            let layout = UICollectionViewFlowLayout()
                                            let homePageVC = UINavigationController(rootViewController: HomePageCollectionViewController(collectionViewLayout: layout))
                                            homePageVC.transitioningDelegate = self
                                            self.navigationController!.present(homePageVC, animated: true)
                                        })
                                        alert.addAction(reportAction)
                                        alert.addAction(noReportAction)
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            } else {
                                print("Something went terribly wrong")
                            }
                        }
                    }
                    print("\(String(describing: responseString))")
                }
                task.resume()
            } else {
                print("Invalid email")
                createErrorAlert(title: "Invalid Email", message: "Please make sure your email is in the proper format", viewController: self)
            }
        } else {
            createErrorAlert(title: "Please Fill In All Fields", message: "In order to create an account, please fill in all required fields.", viewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = Colors.lightBlue
        appDelegate?.registerForPushNotifications(application: UIApplication.shared)
        self.hideKeyboardWhenTappedOutside()
        view.setNeedsUpdateConstraints()
        view.backgroundColor = Colors.lightBlue
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(reenterPasswordLabel)
        view.addSubview(reenterPasswordTextField)
        view.addSubview(createAccountButton)
        
        [firstNameLabel.widthAnchor.constraint(equalToConstant: 310),
         firstNameLabel.heightAnchor.constraint(equalToConstant: 40),
         firstNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), firstNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [firstNameTextField.widthAnchor.constraint(equalToConstant: 310),
         firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
         firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 5), firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [lastNameLabel.widthAnchor.constraint(equalToConstant: 310),
         lastNameLabel.heightAnchor.constraint(equalToConstant: 40),
         lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 5), lastNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [lastNameTextField.widthAnchor.constraint(equalToConstant: 310),
         lastNameTextField.heightAnchor.constraint(equalToConstant: 40),
         lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 5), lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [emailLabel.widthAnchor.constraint(equalToConstant: 310),
         emailLabel.heightAnchor.constraint(equalToConstant: 40),
         emailLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 5), emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [emailTextField.widthAnchor.constraint(equalToConstant: 310),
         emailTextField.heightAnchor.constraint(equalToConstant: 40),
         emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5), emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [passwordLabel.widthAnchor.constraint(equalToConstant: 310),
         passwordLabel.heightAnchor.constraint(equalToConstant: 40),
         passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5), passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [passwordTextField.widthAnchor.constraint(equalToConstant: 310),
         passwordTextField.heightAnchor.constraint(equalToConstant: 40),
         passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5), passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [reenterPasswordLabel.widthAnchor.constraint(equalToConstant: 310),
         reenterPasswordLabel.heightAnchor.constraint(equalToConstant: 40),
         reenterPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5), reenterPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [reenterPasswordTextField.widthAnchor.constraint(equalToConstant: 310),
         reenterPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
         reenterPasswordTextField.topAnchor.constraint(equalTo: reenterPasswordLabel.bottomAnchor, constant: 5), reenterPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [createAccountButton.widthAnchor.constraint(equalToConstant: 210),
         createAccountButton.heightAnchor.constraint(equalToConstant: 50), createAccountButton.topAnchor.constraint(equalTo: reenterPasswordTextField.bottomAnchor, constant: 50), createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        createAccountButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
    }
}
