//
//  Extensions.swift
//  Quick Look Up
//
//  Created by Neal Patel on 10/29/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit
import CommonCrypto
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

extension UIView {
    func addConstraintsWithFormat(format: String, views: [UIView]) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

func MD5(string: String) -> String {
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    return digestData.map { String(format: "%02hhx", $0) }.joined()
}

func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

class TextField: UITextField {
    let padding = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class Colors {
    static var lightBlue = UIColor(red: 0.820, green: 0.933, blue: 1.000, alpha: 1.000)
    static var textBlue = UIColor(red: 0.039, green: 0.027, blue: 0.620, alpha: 1.000)
    static var appleBlue = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1.000)
    static var appleWhite = UIColor(white: 0.95, alpha: 1)
}

class UIUnderlinedLabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}

func createErrorAlert(title: String, message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    DispatchQueue.main.async {
        viewController.present(alert, animated: true, completion: nil)
    }
}

// Core Data Testing
func setupData() {
    let account1 = NSEntityDescription.insertNewObject(forEntityName: "Account", into: PersistenceService.context) as! Account
    account1.id = 10
    let item1 = NSEntityDescription.insertNewObject(forEntityName: "Item", into: PersistenceService.context) as! Item
    item1.id = 5
    item1.detail = "Item id is 5"
    item1.dateFound = "Not found"
    item1.itemType = 2
    item1.account = account1
    let item2 = NSEntityDescription.insertNewObject(forEntityName: "Item", into: PersistenceService.context) as! Item
    item2.id = 6
    item2.detail = "Item id is 6"
    item2.dateFound = "Not found"
    item2.itemType = 3
    item2.account = account1
    
    let msg1 = NSEntityDescription.insertNewObject(forEntityName: "Message", into: PersistenceService.context) as! Message
    msg1.body = "first message for item1"
    let msg2 = NSEntityDescription.insertNewObject(forEntityName: "Message", into: PersistenceService.context) as! Message
    msg2.body = "second message for item1"
    msg1.item = item1
    msg2.item = item1
    item1.addToMessages(msg1)
    item1.addToMessages(msg2)
    
    let msg3 = NSEntityDescription.insertNewObject(forEntityName: "Message", into: PersistenceService.context) as! Message
    msg3.body = "first message for item2"
    let msg4 = NSEntityDescription.insertNewObject(forEntityName: "Message", into: PersistenceService.context) as! Message
    msg4.body = "second message for item2"
    msg3.item = item2
    msg4.item = item2
    item2.addToMessages(msg3)
    item2.addToMessages(msg4)
    
    account1.addToItems(item1)
    account1.addToItems(item2)
    
    PersistenceService.saveContext()
}

func loadData() -> [Account]? {
    do {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        let accounts = try(PersistenceService.context.fetch(fetchRequest)) as? [Account]
        return accounts
    } catch let err {
        print(err.localizedDescription)
    }
    return nil
}

func fetchMessages(account: Account, item: Item) -> [Message]? {
    do {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let accountPredicate = NSPredicate(format: "item.account == %@", account)
        let itemPredicate = NSPredicate(format: "item == %@", item)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [accountPredicate, itemPredicate])
        let messages = try(PersistenceService.context.fetch(fetchRequest)) as? [Message]
        return messages
    } catch let err {
        print(err.localizedDescription)
    }
    return nil
}

func fetchItems(account: Account) -> [Item]? {
    do {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let acctPred = NSPredicate(format: "account == %@", account)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [acctPred])
        let items = try(PersistenceService.context.fetch(fetchRequest)) as? [Item]
        return items
    } catch let err {
        print(err.localizedDescription)
    }
    return nil
}

func fetchAccount(accountID: Int16) -> [Account]? {
    do {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "id == %ld", accountID)
        let accounts = try(PersistenceService.context.fetch(fetchRequest)) as? [Account]
        return accounts
    } catch let err {
        print(err.localizedDescription)
    }
    print("nil")
    return nil
}

func saveMessage(account: Account, item: Item, message: Message) {
    message.item = item
    item.addToMessages(message)
    item.account = account
    account.addToItems(item)
    PersistenceService.saveContext()
}

func clearMessages(account: Account, item: Item) {
    do {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let messages = try(PersistenceService.context.fetch(fetchRequest)) as? [Message]
        if let allMessages = messages {
            for msg in allMessages {
                if msg.item?.account?.id == account.id && msg.item?.id == item.id {
                    PersistenceService.context.delete(msg)
                }
            }
            PersistenceService.saveContext()
        }
    } catch let err {
        print(err.localizedDescription)
    }
}

func clearData() {
    let names = ["Account", "Item", "Message"]
    do {
        for name in names {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let objects = try(PersistenceService.context.fetch(fetchRequest)) as? [NSManagedObject]
            for object in objects ?? [] {
                PersistenceService.context.delete(object)
            }
            try(PersistenceService.context.save())
        }
    } catch let err {
        print(err.localizedDescription)
    }
}
