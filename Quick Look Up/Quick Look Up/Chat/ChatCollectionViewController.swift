//
//  ChatCollectionViewController.swift
//  Quick Look Up
//
//  Created by Neal Patel on 11/28/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

var globalMessages: [Message] = []

class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let currentItem: Item = globalItems[UserDefaults.standard.value(forKey: "indexClicked") as! Int]
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Text Message"
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(Colors.appleBlue, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        globalMessages = []
    }
    
    func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: [inputTextField, sendButton])
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: [inputTextField])
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: [sendButton])
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: [topBorderView])
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: [topBorderView])
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("item id: \(self.currentItem.id)")
        let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int16
        let accounts = fetchAccount(accountID: accountID)
        var account: Account = Account(context: PersistenceService.context)
        let items: [Item]?
        if accounts?.count ?? 0 > 0 {
            if let acct = accounts?[0] {
                account = acct
                items = fetchItems(account: acct)
                if let allItems = items {
                    for curr in allItems {
                        if curr.id == self.currentItem.id {
                            let messages = fetchMessages(account: account, item: curr)
                            if let allMessages = messages {
                                if allMessages.count != 0 {
                                    globalMessages = allMessages
                                    print("fetched messages")
                                }
                            }
                        }
                    }
                }
            }
        }
        self.title = "#\(self.currentItem.id)"
        self.hideKeyboardWhenTappedOutside()
        view.setNeedsUpdateConstraints()
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: [messageInputContainerView])
        view.addConstraintsWithFormat(format: "V:[v0(58)]", views: [messageInputContainerView])
        setupInputComponents()
        
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: "messageCellId")
        collectionView.backgroundColor = UIColor.white
        
        self.bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        appDelegate?.incomingMessageDelegate = self
    }
    
    var keyboardFrame = CGRect()
    var isKeyboardShowing = false
    var keyboardViewEndFrame = CGRect()
    
    @objc func handleKeyboardNotifications(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.keyboardViewEndFrame = view.convert(keyboardFrame, from: view.window)
                self.keyboardFrame = keyboardFrame
                self.isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
                self.bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height: 0
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }) { (completion) in
                    var indexPath: IndexPath?
                    if globalMessages.count > 0 {
                        indexPath = IndexPath(item: globalMessages.count - 1, section: 0)
                    }
                    if self.isKeyboardShowing {
                        if globalMessages.count > 0 {
                            self.collectionView.contentInset.bottom = self.keyboardViewEndFrame.height / 7
                            self.collectionView.scrollToItem(at: indexPath!, at: .bottom, animated: true)
                        }
                    } else {
                        if globalMessages.count > 0 {
                            self.collectionView.contentInset.bottom = 20
                            self.collectionView.scrollToItem(at: indexPath!, at: .bottom, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    @objc func sendMessage() {
        if inputTextField.text != "" {
            let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int
            let serverurl = "http://ec2-54-89-95-237.compute-1.amazonaws.com/ownerMessage.php"
            let requestURL = NSURL(string: serverurl)
            // Creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL! as URL)
            // Setting the method to post
            request.httpMethod = "POST"
            // Set category index
            let postParameters = "accountID=" + String(accountID) + "&itemID=" + String(self.currentItem.id) + "&body=" + self.inputTextField.text!;
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
                            if let msg = dictionary["message"] {
                            }
                            DispatchQueue.main.async {
                                let accounts = fetchAccount(accountID: Int16(accountID))
                                var account: Account = Account(context: PersistenceService.context)
                                let items: [Item]?
                                if accounts?.count ?? 0 > 0 {
                                    if let acct = accounts?[0] {
                                        account = acct
                                        items = fetchItems(account: acct)
                                        if let allItems = items {
                                            for curr in allItems {
                                                if curr.id == self.currentItem.id {
                                                    print("IDS:")
                                                    print(curr.id, self.currentItem.itemType)
                                                    print("sending message")
                                                    let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: PersistenceService.context) as! Message
                                                    message.isSender = true
                                                    message.body = self.inputTextField.text!
                                                    message.item = self.currentItem
                                                    curr.addToMessages(message)
                                                    PersistenceService.saveContext()
                                                    // Fetch again
                                                    let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int16
                                                    let accounts = fetchAccount(accountID: accountID)
                                                    var account: Account = Account(context: PersistenceService.context)
                                                    let items: [Item]?
                                                    if accounts?.count ?? 0 > 0 {
                                                        if let acct = accounts?[0] {
                                                            account = acct
                                                            items = fetchItems(account: acct)
                                                            if let allItems = items {
                                                                for curr in allItems {
                                                                    print(curr.id, self.currentItem.id)
                                                                    if curr.id == self.currentItem.id {
                                                                        let messages = fetchMessages(account: account, item: curr)
                                                                        if let allMessages = messages {
                                                                            if allMessages.count != 0 {
                                                                                globalMessages = allMessages
                                                                                print("fetched messages")
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                self.collectionView.reloadData()
                                self.inputTextField.text = ""
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                                    self.view.layoutIfNeeded()
                                }) { (completion) in
                                    var indexPath: IndexPath?
                                    if globalMessages.count > 0 {
                                        indexPath = IndexPath(item: globalMessages.count - 1, section: 0)
                                    }
                                    if self.isKeyboardShowing {
                                        if globalMessages.count > 0 {
                                            self.collectionView.contentInset.bottom = self.keyboardViewEndFrame.height / 7
                                            self.collectionView.scrollToItem(at: indexPath!, at: .bottom, animated: true)
                                        }
                                    } else {
                                        if globalMessages.count > 0 {
                                            self.collectionView.contentInset.bottom = 20
                                            self.collectionView.scrollToItem(at: indexPath!, at: .bottom, animated: true)
                                        }
                                    }
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
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCellId", for: indexPath) as! ChatCell
        cell.messageTextView.text = globalMessages[indexPath.item].body
        
        if globalMessages.count > 0 {
            let msg = globalMessages[indexPath.item]
            let size = CGSize(width: 250, height: 1000)
            let estimatedFrame = NSString(string: msg.body!).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            if msg.isSender {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 8 - 24 - 4, y: -2, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 24 - 4, y: -4, width: estimatedFrame.width + 16 + 8 + 8, height: estimatedFrame.height + 20 + 4)
                cell.bubbleImageView.tintColor = Colors.appleBlue
                cell.bubbleImageView.image = ChatCell.blueBubbleImage
                cell.messageTextView.textColor = UIColor.white
            } else {
                cell.messageTextView.frame = CGRect(x: 15 + 10 - 10, y: -2, width: estimatedFrame.width + 16 + 10, height: estimatedFrame.height + 20 + 4)
                cell.textBubbleView.frame = CGRect(x: 15 - 4 - 10, y: -8, width: estimatedFrame.width + 16 + 8 + 4 + 14, height: estimatedFrame.height + 20 + 10)
                cell.bubbleImageView.tintColor = Colors.appleWhite
                cell.bubbleImageView.image = ChatCell.grayBubbleImage
                cell.messageTextView.textColor = UIColor.black
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if globalMessages.count > 0 {
            let msg = globalMessages[indexPath.item].body
            let size = CGSize(width: 250, height: 1000)
            let estimatedFrame = NSString(string: msg!).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 35)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
}

class ChatCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = ""
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatCell.grayBubbleImage
        imageView.tintColor = Colors.appleWhite
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    func setupViews() {
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: [bubbleImageView])
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: [bubbleImageView])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatCollectionViewController: IncomingMessageDelegate {
    func didReceiveIncomingMessage() {
        let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int16
        let accounts = fetchAccount(accountID: accountID)
        var account: Account = Account(context: PersistenceService.context)
        let items: [Item]?
        if accounts?.count ?? 0 > 0 {
            if let acct = accounts?[0] {
                account = acct
                items = fetchItems(account: acct)
                if let allItems = items {
                    for curr in allItems {
                        if curr.id == self.currentItem.id {
                            let messages = fetchMessages(account: account, item: curr)
                            if let allMessages = messages {
                                if allMessages.count != 0 {
                                    globalMessages = allMessages
                                    print("fetched messages from core data")
                                }
                            }
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completion) in
                var indexPath: IndexPath?
                if globalMessages.count > 0 {
                    indexPath = IndexPath(item: globalMessages.count - 1, section: 0)
                }
                if self.isKeyboardShowing {
                    if globalMessages.count > 0 {
                        self.collectionView.contentInset.bottom = self.keyboardViewEndFrame.height / 7
                        self.collectionView.scrollToItem(at: indexPath!, at: .bottom, animated: true)
                    }
                } else {
                    if globalMessages.count > 0 {
                        self.collectionView.contentInset.bottom = 20
                        self.collectionView.scrollToItem(at: indexPath!, at: .bottom, animated: true)
                    }
                }
            }
        }
    }
}
