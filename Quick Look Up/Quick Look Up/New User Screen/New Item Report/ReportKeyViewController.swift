//
//  ReportKeyViewController.swift
//  Quick Look Up
//
//  Created by Neal Patel on 11/27/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit

class ReportKeyViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var keyTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Type of Car Key*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    let categories = ["Traditional Car Key With No Buttons", "Traditional Car Key With Buttons", "Traditional Key With Remote", "Traditional Key Without Remote", "Remote With Key", "Remote Without Key"]
    var selectedCategory: String?
    
    var keyTypeTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.textColor = Colors.textBlue
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    var brandNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Brand Name of Key*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    let brandNames = ["Ford", "Toyota", "Honda", "Chevrolet", "Subaru", "Volswagen", "Audi", "Hyundai", "Nissan", "Other"]
    var selectedBrandName: String = ""
    var brandTypePickerView = UIPickerView()
    var brandsPickerView = UIPickerView()
    
    var brandNameTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.layer.borderWidth = 1
        textField.textColor = Colors.textBlue
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    var numberOfKeysLabel: UILabel = {
        let label = UILabel()
        label.text = "Number of Keys*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    let numOfKeys = ["1", "2", "3-5", "5-10", "10-15", "More than 15"]
    var selectedNumberOfKeys: String?
    
    var numberOfKeysTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.layer.borderWidth = 1
        textField.textColor = Colors.textBlue
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    var keyTypePickerView = UIPickerView()
    var numberOfKeysPickerView = UIPickerView()
    
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
        textView.layer.borderWidth = 1
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = Colors.lightBlue
        textView.textColor = Colors.textBlue
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
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        textField.inputView = datePicker
        textField.placeholder = "Pick a date..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = Colors.textBlue.cgColor
        textField.textColor = Colors.textBlue
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
        if !(keyTypeTextField.text?.isEmpty)! && !(brandNameTextField.text?.isEmpty)! && !(numberOfKeysTextField.text?.isEmpty)! {
            // Item report
            let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int
            let serverurl = "http://ec2-54-89-95-237.compute-1.amazonaws.com/insertItem.php"
            let categoryIndex = UserDefaults.standard.value(forKey: "categoryIndex") as! Int
            let location = locationTextView.text!
            let firstName = UserDefaults.standard.value(forKey: "firstName") as! String
            let lastName = UserDefaults.standard.value(forKey: "lastName") as! String
            let description = "\(keyTypeTextField.text!), \(brandNameTextField.text!), \(numberOfKeysTextField.text!) keys"
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
            createErrorAlert(title: "Not Enough Info Given", message: "In order to report your keys, please fill in all required fields.", viewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = Colors.lightBlue
        self.hideKeyboardWhenTappedOutside()
        view.backgroundColor = Colors.lightBlue
        view.needsUpdateConstraints()
        view.addSubview(keyTypeLabel)
        view.addSubview(keyTypeTextField)
        view.addSubview(brandNameLabel)
        view.addSubview(brandNameTextField)
        view.addSubview(numberOfKeysLabel)
        view.addSubview(numberOfKeysTextField)
        view.addSubview(locationLabel)
        view.addSubview(locationTextView)
        view.addSubview(dateTimeLabel)
        view.addSubview(dateTimeTextField)
        view.addSubview(nextButton)
        
        keyTypePickerView = UIPickerView()
        keyTypeTextField.inputView = keyTypePickerView
        keyTypePickerView.backgroundColor = Colors.lightBlue
        keyTypePickerView.delegate = self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Colors.lightBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        keyTypeTextField.inputAccessoryView = toolBar
        keyTypeTextField.placeholder = "Pick a Type of Key..."
        
        brandsPickerView = UIPickerView()
        brandNameTextField.inputView = brandsPickerView
        brandsPickerView.backgroundColor = Colors.lightBlue
        brandsPickerView.delegate = self
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        brandNameTextField.inputAccessoryView = toolBar
        brandNameTextField.placeholder = "Pick a Type of Brand..."
        
        [keyTypeLabel.widthAnchor.constraint(equalToConstant: 310),
         keyTypeLabel.heightAnchor.constraint(equalToConstant: 40),
         keyTypeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), keyTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [keyTypeTextField.widthAnchor.constraint(equalToConstant: 310),
         keyTypeTextField.heightAnchor.constraint(equalToConstant: 40),
         keyTypeTextField.topAnchor.constraint(equalTo: keyTypeLabel.topAnchor, constant: 50),
         keyTypeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [brandNameLabel.widthAnchor.constraint(equalToConstant: 310),
         brandNameLabel.heightAnchor.constraint(equalToConstant: 40),
         brandNameLabel.topAnchor.constraint(equalTo: keyTypeTextField.topAnchor, constant: 50),
         brandNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [brandNameTextField.widthAnchor.constraint(equalToConstant: 310),
         brandNameTextField.heightAnchor.constraint(equalToConstant: 40),
         brandNameTextField.topAnchor.constraint(equalTo: brandNameLabel.topAnchor, constant: 50),
         brandNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        numberOfKeysTextField.inputView = numberOfKeysPickerView
        numberOfKeysPickerView.backgroundColor = Colors.lightBlue
        numberOfKeysPickerView.delegate = self
        numberOfKeysTextField.inputAccessoryView = toolBar
        numberOfKeysTextField.placeholder = "Pick a Type of Key..."
        
        [numberOfKeysLabel.widthAnchor.constraint(equalToConstant: 310),
         numberOfKeysLabel.heightAnchor.constraint(equalToConstant: 40),
         numberOfKeysLabel.topAnchor.constraint(equalTo: brandNameTextField.topAnchor, constant: 50),
         numberOfKeysLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [numberOfKeysTextField.widthAnchor.constraint(equalToConstant: 310),
         numberOfKeysTextField.heightAnchor.constraint(equalToConstant: 40),
         numberOfKeysTextField.topAnchor.constraint(equalTo: numberOfKeysLabel.topAnchor, constant: 50),
         numberOfKeysTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [locationLabel.widthAnchor.constraint(equalToConstant: 310),
         locationLabel.heightAnchor.constraint(equalToConstant: 40),
         locationLabel.topAnchor.constraint(equalTo: numberOfKeysTextField.bottomAnchor, constant: 5), locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
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

extension ReportKeyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if pickerView == keyTypePickerView {
            count = self.categories.count
        } else if pickerView == numberOfKeysPickerView {
            count = self.numOfKeys.count
        } else if pickerView == brandsPickerView {
            count = self.brandNames.count
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var string = ""
        if pickerView == keyTypePickerView {
            string = self.categories[row]
        } else if pickerView == numberOfKeysPickerView {
            string = self.numOfKeys[row]
        } else if pickerView == brandsPickerView {
            string = self.brandNames[row]
        }
        return string
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == keyTypePickerView {
            self.selectedCategory = self.categories[row]
            keyTypeTextField.text = self.selectedCategory
        } else if pickerView == numberOfKeysPickerView {
            self.selectedNumberOfKeys = self.numOfKeys[row]
            numberOfKeysTextField.text = self.selectedNumberOfKeys
        } else if pickerView == brandsPickerView {
            self.selectedBrandName = self.brandNames[row]
            brandNameTextField.text = self.selectedBrandName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textAlignment = .center
        label.font = label.font.withSize(18)
        
        if pickerView == keyTypePickerView {
            label.text = self.categories[row]
        } else if pickerView == numberOfKeysPickerView {
            label.text = self.numOfKeys[row]
        } else if pickerView == brandsPickerView {
            label.text = self.brandNames[row]
        }
        
        return label
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
}
