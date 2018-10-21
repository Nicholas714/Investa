//
//  TransactionCell.swift
//  Investa
//
//  Created by Nicholas Grana on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
    @IBOutlet weak var shareCount: UILabel!
    @IBOutlet weak var toalGain: UILabel!
    
    var transaction: Transaction! {
        didSet {
            APIManager.shared.getStock(identifier: transaction.ticker, onSuccess: { (stock) in
                self.stockName.text = stock.ticker
                self.stockPrice.text = "\(stock.currentPrice.moneyFormat)"
                self.shareCount.text = "\(self.transaction.shares) share\(self.transaction.shares > 1 ? "s" : "")"
                self.toalGain.text = "\((stock.currentPrice * Float(self.transaction.shares) - self.transaction.buyPrice * Float(self.transaction.shares)).moneyFormat)"
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "MM/dd/yy"
                self.date.text = dateFormatterGet.string(from: self.transaction.getDate()!)
            }) { (error) in
                print("ERROR! \(error)")
            }

        }
    }
    
}

extension Float {
    
    var moneyFormat: String {
        return String(format: "$%.02f", self)
    }
    
}
