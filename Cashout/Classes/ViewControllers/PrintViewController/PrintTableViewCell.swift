//
//  PrintTableViewCell.swift
//  Cashout
//
//  Created by Simardeep Singh Jauhar on 06/05/19.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit

class PrintTableViewCell: UITableViewCell {

    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureItem(item:Item) {
        self.lblItemName.text = "\(item.name)"
        self.lblItemPrice.text = "\(item.price)"
    }

}
