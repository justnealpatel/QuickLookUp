//
//  CategoryPickerViewController.swift
//  Quick Look Up
//
//  Created by Neal Patel on 11/27/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UIViewController, UITextFieldDelegate {

    let categories = ["Wallet", "Keys", "Prescription"]
    var selectedCategory: String?
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category*"
        label.font = UIFont(name: "Futura", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = Colors.lightBlue
        label.textColor = Colors.textBlue
        return label
    }()
    
    var categoryTextField: TextField = {
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
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
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
    
    @objc func moreDetails() {
        print("More details")
        if !(categoryTextField.text?.isEmpty)! {
            var categoryIndex = 0
            var i = 1
            for category in categories {
                if category == self.categoryTextField.text! {
                    categoryIndex = i
                    break
                }
                i += 1
            }
            UserDefaults.standard.set(categoryIndex, forKey: "categoryIndex")
            // Go to proper screen
            if i == 1 {
                // Wallet
                let reportWalletVC = UINavigationController(rootViewController: ReportWalletViewController())
                self.navigationController!.present(reportWalletVC, animated: true)
            } else if i == 2 {
                // Keys
                let reportKeyVC = UINavigationController(rootViewController: ReportKeyViewController())
                self.present(reportKeyVC, animated: true)
            } else if i == 3 {
                // Prescription
                let reportPrescriptionVC = UINavigationController(rootViewController: ReportPrescriptionViewController())
                self.navigationController!.present(reportPrescriptionVC, animated: true)
            }
        } else {
            createErrorAlert(title: "No Category Chosen", message: "In order to report an item, please choose a category for your item that was lost.", viewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = Colors.lightBlue
        categoryTextField.delegate = self
        view.backgroundColor = Colors.lightBlue
        self.hideKeyboardWhenTappedOutside()
        view.setNeedsUpdateConstraints()
        view.addSubview(categoryLabel)
        view.addSubview(categoryTextField)
        view.addSubview(nextButton)
        
        let categoryPickerView = UIPickerView()
        categoryTextField.inputView = categoryPickerView
        categoryPickerView.backgroundColor = Colors.lightBlue
        categoryPickerView.delegate = self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Colors.lightBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolBar
        categoryTextField.placeholder = "Pick a Category..."
        
        [categoryLabel.widthAnchor.constraint(equalToConstant: 310),
         categoryLabel.heightAnchor.constraint(equalToConstant: 40),
         categoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 170), categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [categoryTextField.widthAnchor.constraint(equalToConstant: 310),
         categoryTextField.heightAnchor.constraint(equalToConstant: 40),
         categoryTextField.topAnchor.constraint(equalTo: categoryLabel.topAnchor, constant: 50),
         categoryTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        
        [nextButton.widthAnchor.constraint(equalToConstant: 110),
         nextButton.heightAnchor.constraint(equalToConstant: 50), nextButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 50), nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach{ $0.isActive = true }
        nextButton.addTarget(self, action: #selector(moreDetails), for: .touchUpInside)
    }
}

extension CategoryPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = self.categories[row]
        categoryTextField.text = self.selectedCategory
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
        
        label.text = self.categories[row]
        
        return label
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
}
