//
//  SearchStockCell.swift
//  Investa
//
//  Created by Nicholas Grana on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

class SearchStockCell: UITableViewCell {
    
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
    
    var stock: Stock! {
        didSet {
            stockName.text = stock.ticker
            stockPrice.text = stock.currentPrice.moneyFormat
        }
    }
    
}
