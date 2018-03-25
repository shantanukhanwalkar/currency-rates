//
//  CurrencyRateTableViewCell.swift
//  CurrencyRates
//
//  Created by Shantanu Khanwalkar on 22/03/18.
//  Copyright © 2018 Shantanu Khanwalkar. All rights reserved.
//

import UIKit

class CurrencyRateTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
