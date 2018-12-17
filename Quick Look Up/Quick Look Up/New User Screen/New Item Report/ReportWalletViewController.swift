//
//  ReportWalletViewController.swift
//  Quick Look Up
//
//  Created by Neal Patel on 11/27/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit

class ReportWalletViewController: UIViewController, UIViewControllerTransitioningDelegate {

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
    
    var colorPatternsLabel: UILabel = {
        let label = UILabel()
        label.text = "Colors and patterns on the wallet"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var colorPatternsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Colors.lightBlue
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = Colors.textBlue.cgColor
        textView.textColor = Colors.textBlue
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.autocapitalizationType = .sentences
        textView.textContainerInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return textView
    }()
    
    var brandNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Brand Name of Wallet*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var brandNameTextField: TextField = {
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
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description of Wallet*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var descriptionTextField: TextField = {
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
        textView.textColor = Colors.textBlue
        textView.backgroundColor = Colors.lightBlue
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
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = Colors.lightBlue
        datePicker.setValue(Colors.textBlue, forKey: "textColor")
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        textField.inputView = datePicker
        textField.placeholder = "Pick a date..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.textColor = Colors.textBlue
        textField.layer.borderWidth = 1
        textField.inputView?.backgroundColor = Colors.lightBlue
        textField.inputView?.setValue(Colors.textBlue, forKey: "textColor")
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
        if !(firstNameTextField.text?.isEmpty)! && !(lastNameTextField.text?.isEmpty)! && !(colorPatternsTextView.text.isEmpty) && !(brandNameTextField.text?.isEmpty)! && !(descriptionTextField.text?.isEmpty)! {
            // Item report
            let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int
            let serverurl = "http://ec2-54-89-95-237.compute-1.amazonaws.com/insertItem.php"
            let categoryIndex = UserDefaults.standard.value(forKey: "categoryIndex") as! Int
            let location = locationTextView.text!
            let firstName = UserDefaults.standard.value(forKey: "firstName") as! String
            let lastName = UserDefaults.standard.value(forKey: "lastName") as! String
            let description = "\(firstName) \(lastName), \(colorPatternsTextView.text!), \(brandNameTextField.text!), \(descriptionTextField.text!)"
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
                                    self.present(homePageVC, animated: true, completion: nil)
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
        view.backgroundColor = Colors.lightBlue
        view.setNeedsUpdateConstraints()
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        view.addSubview(colorPatternsLabel)
        view.addSubview(colorPatternsTextView)
        view.addSubview(brandNameLabel)
        view.addSubview(brandNameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
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
        
        [colorPatternsLabel.widthAnchor.constraint(equalToConstant: 310),
         colorPatternsLabel.heightAnchor.constraint(equalToConstant: 40),
         colorPatternsLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 5), colorPatternsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [colorPatternsTextView.widthAnchor.constraint(equalToConstant: 310),
         colorPatternsTextView.heightAnchor.constraint(equalToConstant: 40),
         colorPatternsTextView.topAnchor.constraint(equalTo: colorPatternsLabel.bottomAnchor, constant: 5), colorPatternsTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        colorPatternsTextView.delegate = self
        colorPatternsTextView.isScrollEnabled = false
        textViewDidChange(colorPatternsTextView)
        
        [brandNameLabel.widthAnchor.constraint(equalToConstant: 310),
         brandNameLabel.heightAnchor.constraint(equalToConstant: 40),
         brandNameLabel.topAnchor.constraint(equalTo: colorPatternsTextView.topAnchor, constant: 45), brandNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [brandNameTextField.widthAnchor.constraint(equalToConstant: 310),
         brandNameTextField.heightAnchor.constraint(equalToConstant: 40),
         brandNameTextField.topAnchor.constraint(equalTo: brandNameLabel.bottomAnchor, constant: 5), brandNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [descriptionLabel.widthAnchor.constraint(equalToConstant: 310),
         descriptionLabel.heightAnchor.constraint(equalToConstant: 40),
         descriptionLabel.topAnchor.constraint(equalTo: brandNameTextField.bottomAnchor, constant: 5), descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [descriptionTextField.widthAnchor.constraint(equalToConstant: 310),
         descriptionTextField.heightAnchor.constraint(equalToConstant: 40),
         descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5), descriptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [locationLabel.widthAnchor.constraint(equalToConstant: 310),
         locationLabel.heightAnchor.constraint(equalToConstant: 40),
         locationLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 5), locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
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

extension ReportWalletViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: 310, height: Double.greatestFiniteMagnitude)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        brandNameLabel.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .top {
                constraint.constant += estimatedSize.height
            }
        }
        brandNameTextField.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .top {
                constraint.constant += estimatedSize.height
            }
        }
    }
}
