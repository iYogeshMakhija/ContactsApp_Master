//
//  ContactListViewController.swift
//  Contacts app
//
//  Created by apple on 25/12/18.
//  Copyright © 2018 Yogesh Makhija. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var contacts = [Contact]()
    private var filtered = [Contact]()
    private var isFiltered = false
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            contacts = try context.fetch(Contact.fetchRequest())
        }catch let error as NSError {
            print("could not fetch. \(error), \(error.userInfo)")
        }
    }


    @IBAction func addContactAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toAddContact", sender: self)
    }
    
}


extension ContactListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = isFiltered ? filtered.count : contacts.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let contactCell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as? ContactDetailTableViewCell{
            
            let contact = isFiltered ? filtered[indexPath.row] : contacts[indexPath.row]
            contactCell.fullName.text = contact.fullName ?? ""
            contactCell.phoneNumber.text = contact.phoneNumber
            if let data = contact.image as Data? {
                contactCell.contactImage.image = UIImage(data: data)
            } else {
                contactCell.contactImage.image = UIImage(named: "user")
            }
            return contactCell
        }
        return UITableViewCell()
    }
}

extension ContactListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// Search Bar Delegate
extension ContactListViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        isFiltered = true

        filtered = contacts.filter({(contact) -> Bool in
            if contact.fullName!.contains(query.lowercased()) {
                return true
            } else if contact.fullName!.contains(query) {
                return true
            } else {
                return false
            }
        })
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            isFiltered = false
            filtered.removeAll()
            searchBar.text = nil
            searchBar.resignFirstResponder()
            tableView.reloadData()
        }
        
        if let searchText = searchBar.text {
            let query = searchText.replacingOccurrences(of: " ", with: " ")
            isFiltered = true
            
            filtered = contacts.filter({(contact) -> Bool in
                if contact.fullName!.contains(query.lowercased()) {
                    return true
                } else if contact.fullName!.contains(query) {
                    return true
                } else {
                    return false
                }
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltered = false
        filtered.removeAll()
        searchBar.text = nil
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
}
