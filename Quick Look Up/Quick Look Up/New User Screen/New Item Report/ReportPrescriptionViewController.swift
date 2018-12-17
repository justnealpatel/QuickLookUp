//
//  ReportPrescriptionViewController.swift
//  Quick Look Up
//
//  Created by Neal Patel on 11/27/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit

class ReportPrescriptionViewController: UIViewController, UIViewControllerTransitioningDelegate {

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
        textField.textColor = Colors.textBlue
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
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
    
    var prescriptionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name of Prescription*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var prescriptionNameTextField: TextField = {
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
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location of where item was lost*"
        label.font = UIFont(name: "Futura", size: 18)
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        label.layer.cornerRadius = 5
        return label
    }()
    
    var locationTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = Colors.textBlue.cgColor
        textView.backgroundColor = Colors.lightBlue
        textView.textColor = Colors.textBlue
        textView.layer.borderWidth = 1
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.autocapitalizationType = .sentences
        return textView
    }()
    
    var dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time of when item was lost"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var dateTimeTextField: TextField = {
        let textField = TextField()
        var datePicker = UIDatePicker()
        datePicker.backgroundColor = Colors.lightBlue
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        textField.inputView = datePicker
        textField.placeholder = "Pick a date..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.textColor = Colors.textBlue
        textField.backgroundColor = Colors.lightBlue
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateTimeTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Report Item", for: .normal)
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
    
    @objc func finishReport() {
        // Report item and create account
        if !(firstNameTextField.text?.isEmpty)! && !(lastNameTextField.text?.isEmpty)! && !(prescriptionNameTextField.text?.isEmpty)! {
            // Item report
            let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int
            let serverurl = "http://ec2-54-89-95-237.compute-1.amazonaws.com/insertItem.php"
            let categoryIndex = UserDefaults.standard.value(forKey: "categoryIndex") as! Int
            let location = locationTextView.text!
            let firstName = UserDefaults.standard.value(forKey: "firstName") as! String
            let lastName = UserDefaults.standard.value(forKey: "lastName") as! String
            let description = "\(firstName) \(lastName), \(prescriptionNameTextField.text!)"
            var postParameters: String
            postParameters = "firstName=" + firstName + "&lastName=" + lastName + "&description=" + description + "&itemType=" + String(categoryIndex) + "&accountID=" + String(accountID)
            if !(dateTimeTextField.text?.isEmpty)! {
                let combinedDateTime = dateTimeTextField.text!.components(separatedBy: " ")
                let dateLost = combinedDateTime[0]
                let timeLost = combinedDateTime[1]
                postParameters += "&dateLost=" + dateLost + "&timeLost=" + timeLost
                print(dateLost)
                print(timeLost)
            }
            if !(locationTextView.text.isEmpty) {
                postParameters += "&lastLocation=" + location
            }
            let requestURL = NSURL(string: serverurl)
            let request = NSMutableURLRequest(url: requestURL! as URL)
            request.httpMethod = "POST"
            request.httpBody = postParameters.data(using: String.Encoding.utf8)
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
                            DispatchQueue.main.async {
                                // Ask to change to new account view controller
                                print("Item reported")
                                justReported = true
                                let alert = UIAlertController(title: "Item Reported", message: "We have successfully reported your lost item.", preferredStyle: .alert)
                                let homePageAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                    let layout = UICollectionViewFlowLayout()
                                    let homePageVC = UINavigationController(rootViewController: HomePageCollectionViewController(collectionViewLayout: layout))
                                    homePageVC.transitioningDelegate = self
                                    self.navigationController!.present(homePageVC, animated: true)
                                }
                                alert.addAction(homePageAction)
                                self.present(alert, animated: true)
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
            createErrorAlert(title: "Not Enough Info Given", message: "In order to report your wallet, please fill in all required fields.", viewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = Colors.lightBlue
        self.hideKeyboardWhenTappedOutside()
        view.setNeedsUpdateConstraints()
        view.backgroundColor = Colors.lightBlue
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        view.addSubview(prescriptionNameLabel)
        view.addSubview(prescriptionNameTextField)
        view.addSubview(locationLabel)
        view.addSubview(locationTextView)
        view.addSubview(dateTimeLabel)
        view.addSubview(dateTimeTextField)
        view.addSubview(nextButton)
        
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
        
        [prescriptionNameLabel.widthAnchor.constraint(equalToConstant: 310),
         prescriptionNameLabel.heightAnchor.constraint(equalToConstant: 40),
         prescriptionNameLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 5), prescriptionNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [prescriptionNameTextField.widthAnchor.constraint(equalToConstant: 310),
         prescriptionNameTextField.heightAnchor.constraint(equalToConstant: 40),
         prescriptionNameTextField.topAnchor.constraint(equalTo: prescriptionNameLabel.bottomAnchor, constant: 5), prescriptionNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [locationLabel.widthAnchor.constraint(equalToConstant: 310),
         locationLabel.heightAnchor.constraint(equalToConstant: 40),
         locationLabel.topAnchor.constraint(equalTo: prescriptionNameTextField.bottomAnchor, constant: 5), locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [locationTextView.widthAnchor.constraint(equalToConstant: 310),
         locationTextView.heightAnchor.constraint(equalToConstant: 40),
         locationTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5), locationTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [dateTimeLabel.widthAnchor.constraint(equalToConstant: 310),
         dateTimeLabel.heightAnchor.constraint(equalToConstant: 40),
         dateTimeLabel.topAnchor.constraint(equalTo: locationTextView.bottomAnchor, constant: 5), dateTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [dateTimeTextField.widthAnchor.constraint(equalToConstant: 310),
         dateTimeTextField.heightAnchor.constraint(equalToConstant: 40),
         dateTimeTextField.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 5), dateTimeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [nextButton.widthAnchor.constraint(equalToConstant: 130),
         nextButton.heightAnchor.constraint(equalToConstant: 70), nextButton.topAnchor.constraint(equalTo: dateTimeTextField.bottomAnchor, constant: 20), nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        nextButton.addTarget(self, action: #selector(finishReport), for: .touchUpInside)
    }
}
