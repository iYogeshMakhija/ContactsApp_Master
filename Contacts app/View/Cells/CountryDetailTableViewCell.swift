//
//  CountryDetailTableViewCell.swift
//  Contacts app
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Yogesh Makhija. All rights reserved.
//

import UIKit

class CountryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
