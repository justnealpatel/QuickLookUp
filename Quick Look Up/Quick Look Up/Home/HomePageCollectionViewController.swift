//
//  HomePageCollectionViewController.swift
//  Quick Look Up
//
//  Created by Neal Patel on 11/27/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

var justReported = false
var globalItems: [Item] = []

extension Item {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

//extension Message {
//    static func == (lhs: Message, rhs: Message) -> Bool {
//        return lhs.id
//    }
//}

class HomePageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SwipeCollectionViewCellDelegate {
    
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = true
    var isSwipeLeftEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = Colors.lightBlue
        globalItems = []
        self.collectionView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        // Load items for saved accountID
        let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int16
        print("account: \(accountID)")
        let accounts = fetchAccount(accountID: accountID)
        var account: Account = Account(context: PersistenceService.context)
        let items: [Item]?
        if accounts?.count ?? 0 > 0 {
            if let acct = accounts?[0] {
                account = acct
                items = fetchItems(account: acct)
                if let allItems = items {
                    for currItem in allItems {
                        var flag = false
                        for curr in globalItems {
                            if currItem.id == curr.id && !currItem.shouldRedact {
                                flag = true
                            }
                        }
                        if !flag {
                            globalItems.append(currItem)
                        }
                    }
                    print("fetched items")
                }
            }
        }
        let serverurl = "http://ec2-54-89-95-237.compute-1.amazonaws.com/getItemIDs.php"
        let requestURL = NSURL(string: serverurl)
        // Creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        // Setting the method to post
        request.httpMethod = "POST"
        // Creating the post parameter by concatenating the keys and values from text field
        let postParameters = "accountID=" + String(accountID);
        // Adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        // Creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
//            print("response = \(String(describing: response))")
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("responseString = \(String(describing: responseString))")
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            if let dictionary = json as? [String: Any] {
                if let error = dictionary["error"] as? Bool {
                    if !error {
                        if let valueArrays = dictionary["valueArrays"] as? NSArray {
                            if valueArrays.count == 1 {
                                if let item = valueArrays[0] as? NSArray {
                                    let itemArray = NSEntityDescription.insertNewObject(forEntityName: "Item", into: PersistenceService.context) as! Item
                                    if (item[0] as? Int) != nil {
                                        itemArray.id = item[0] as! Int16
                                    }
                                    if (item[1] as? Int) != nil {
                                        itemArray.itemType = item[1] as! Int16
                                    }
                                    if (item[2] as? String) != nil {
                                        itemArray.detail = (item[2] as! String)
                                    }
                                    if (item[3] as? String) == nil {
                                        itemArray.dateFound = "Not Found Yet"
                                    } else {
                                        itemArray.dateFound = (item[3] as! String)
                                    }
                                    itemArray.isExpired = false
                                    itemArray.shouldRedact = false
                                    itemArray.account = account
                                    var flag = false
                                    for curr in globalItems {
                                        if itemArray.id == curr.id {
                                            print("duplicate from db")
                                            flag = true
                                            break
                                        }
                                    }
                                    if !flag {
                                        print("add item")
                                        globalItems.append(itemArray)
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            }
                            if valueArrays.count > 1 {
                                for index in 0...valueArrays.count-1 {
                                    if let item = valueArrays[index] as? NSArray {
                                        let itemArray = NSEntityDescription.insertNewObject(forEntityName: "Item", into: PersistenceService.context) as! Item
                                        if (item[0] as? Int) != nil {
                                            itemArray.id = item[0] as! Int16
                                        }
                                        if (item[1] as? Int) != nil {
                                            itemArray.itemType = item[1] as! Int16
                                        }
                                        if (item[2] as? String) != nil {
                                            itemArray.detail = (item[2] as! String)
                                        }
                                        if (item[3] as? String) == nil {
                                            itemArray.dateFound = "Not Found Yet"
                                        } else {
                                            itemArray.dateFound = (item[3] as! String)
                                        }
                                        itemArray.isExpired = false
                                        itemArray.shouldRedact = false
                                        itemArray.account = account
                                        print(itemArray)
                                        var flag = false
                                        for curr in globalItems {
                                            print(itemArray.id, curr.id)
                                            if itemArray.id == curr.id {
                                                print("duplicate from db")
                                                flag = true
                                                break
                                            }
                                        }
                                        if !flag {
                                            print("add item")
                                            globalItems.append(itemArray)
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        self.collectionView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        task.resume()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Report Item", style: .plain, target: self, action: #selector(reportItem))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    @objc func signOut() {
        UserDefaults.standard.set(nil, forKey: "accountID")
        UserDefaults.standard.set(nil, forKey: "firstName")
        UserDefaults.standard.set(nil, forKey: "lastName")
        self.navigationController!.present(UINavigationController(rootViewController: WelcomeViewController()), animated: true)
    }
    
    @objc func reportItem() {
        let categoryPickerVC = CategoryPickerViewController()
        self.navigationController!.present(UINavigationController(rootViewController: categoryPickerVC), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        globalMessages = []
        UserDefaults.standard.set(indexPath.item, forKey: "indexClicked")
        let layout = UICollectionViewFlowLayout()
        let chatPageVC = ChatCollectionViewController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(chatPageVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        let item = items[indexPath.row]
        var arr: [SwipeAction] = []
        if orientation == .left {
            let foundAction = SwipeAction(style: .destructive, title: "Found") { action, indexPath in
                // handle action by updating model with deletion
                print("Found")
                let itemID = globalItems[indexPath.item].id
                let serverurl = "http://ec2-54-89-95-237.compute-1.amazonaws.com/redact.php"
                let requestURL = NSURL(string: serverurl)
                print(itemID)
                // Creating NSMutableURLRequest
                let request = NSMutableURLRequest(url: requestURL! as URL)
                // Setting the method to post
                request.httpMethod = "POST"
                // Creating the post parameter by concatenating the keys and values from text field
                let postParameters = "itemID=" + String(Int(itemID));
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
                                globalItems.remove(at: indexPath.item)
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Incorrect Email or Password", message: "We could not find an account associated with your email or password. Please try again.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                }
                            }
                        }
                    }
                }
                task.resume()
            }
            foundAction.transitionDelegate = ScaleTransition.default
            arr.append(foundAction)
        } else if orientation == .right {
            let deleteAction = SwipeAction(style: .destructive, title: "Delete Chat") { action, indexPath in
                // handle action by updating model with deletion
                print("Delete")
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
                                if curr.id == globalItems[indexPath.item].id {
                                    clearMessages(account: acct, item: curr)
                                    globalMessages = []
                                    curr.shouldRedact = true
                                }
                            }
                        }
                    }
                }
            }
            deleteAction.transitionDelegate = ScaleTransition.default
            arr.append(deleteAction)
        }
        return arr
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        globalMessages = []
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ItemCell
        cell.delegate = self
        var type = ""
        if globalItems[indexPath.item].itemType == 1 {
            type = "Wallet"
        }
        if globalItems[indexPath.item].itemType == 2 {
            type = "Keys"
        }
        if globalItems[indexPath.item].itemType == 3 {
            type = "Prescription"
        }
        cell.idLabel.text = "#\(globalItems[indexPath.item].id)"
        cell.descriptionLabel.text = type
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        print(indexPath.item)
    }
}

class ItemCell: SwipeCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let cellDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Colors.textBlue
        label.backgroundColor = Colors.lightBlue
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 37.5)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.backgroundColor = Colors.lightBlue
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 37.5)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func prepareForReuse() {
        self.contentView.frame = self.bounds
    }
    
    func setupViews() {
        self.contentView.addSubview(cellDividerView)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(idLabel)
        
        self.contentView.backgroundColor = Colors.lightBlue
        backgroundColor = Colors.lightBlue
        
        // Description Label
        addConstraintsWithFormat(format: "H:|-150-[v0][v1]", views: [descriptionLabel, idLabel])
        addConstraintsWithFormat(format: "V:|-15-[v0]|", views: [descriptionLabel])
        addConstraintsWithFormat(format: "V:|-15-[v0]|", views: [idLabel])
        
        // Cell Divider
        addConstraintsWithFormat(format: "H:|[v0]|", views: [cellDividerView])
        addConstraintsWithFormat(format: "V:[v0][v1(1)]", views: [descriptionLabel, cellDividerView])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}
