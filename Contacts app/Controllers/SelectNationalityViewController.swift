//
//  SelectNationalityViewController.swift
//  Contacts app
//
//  Created by apple on 25/12/18.
//  Copyright © 2018 Yogesh Makhija. All rights reserved.
//

import UIKit

protocol SelectNationalityDelegate {
    func selected(country: Country)
}

class SelectNationalityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let queryService = CountryQueryService()
    var countries : [Country] = []
    var delegate: SelectNationalityDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        queryService.getCountries() { results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let results = results {
                self.countries = results
                self.tableView.reloadData()
//                self.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SelectNationalityViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let countryCell = tableView.dequeueReusableCell(withIdentifier: "countryList", for: indexPath) as? CountryDetailTableViewCell else {
            
            return UITableViewCell()
        }
        
        countryCell.countryName.text = self.countries[indexPath.row].countryName
        return countryCell
    }
}

extension SelectNationalityViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.delegate?.selected(country: self.countries[indexPath.row])
            self.navigationController?.popViewController(animated: true)
    }
    
}
