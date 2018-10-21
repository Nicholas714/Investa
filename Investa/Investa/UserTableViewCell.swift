//
//  UserTableViewCell.swift
//  Investa
//
//  Created by Cameron Bennett on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var totalFunds: UILabel!
    @IBOutlet weak var percentChange: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
