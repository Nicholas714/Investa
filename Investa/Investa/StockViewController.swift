//
//  StockViewController.swift
//  Investa
//
//  Created by Nicholas Grana on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

class StockViewController: UIViewController {
    
    @IBOutlet weak var stockLineGraphView: StockLineGraphView!
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.text = stock.ticker
        }
    }
    @IBOutlet weak var price: UILabel! {
        didSet {
            price.text = stock.currentPrice.moneyFormat
        }
    }
    @IBOutlet weak var funds: UILabel! {
        didSet {
            funds.text = APIManager.shared.user!.funds.moneyFormat
        }
    }
    @IBOutlet weak var ownedSales: UILabel! {
        didSet {
            let currentStocks = APIManager.shared.user!.ownedStocks.filter { $0 == stock && stock.sharesOwned != 0 }
            ownedSales.text = "\(currentStocks.count)"
        }
    }
    @IBOutlet weak var shareWorth: UILabel! {
        didSet {
            let currentStocks = APIManager.shared.user!.ownedStocks.filter { $0 == stock && stock.sharesOwned != 0 }
            shareWorth.text = "\((Float(currentStocks.count) * stock.currentPrice).moneyFormat)"
        }
    }
    @IBOutlet weak var transactions: UILabel! {
        didSet {
            transactions.text = "\(APIManager.shared.user!.transactions.filter { $0.ticker == stock.ticker }.count)"
        }
    }
    
    var stock: Stock! 
    
    func reload() {
        
        let currentStocks = APIManager.shared.user!.ownedStocks.filter { $0 == stock }
        name.text = stock.ticker
        funds.text = APIManager.shared.user!.funds.moneyFormat
        price.text = stock.currentPrice.moneyFormat
        ownedSales.text = "\(currentStocks.count)"
        shareWorth.text = "\((Float(currentStocks.count) * stock.currentPrice).moneyFormat)"
        transactions.text = "\(APIManager.shared.user!.transactions.filter { $0.ticker == stock.ticker }.count)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Stock"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        stockLineGraphView.setDataCount(20, range: 20)
        stockLineGraphView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.40)

    }
    
    @IBAction func clickSell(_ sender: StockOptionButton) {
        
        if stock.sharesOwned == 0 {
            self.showAlert(title: "You do not have any stocks to sell.")
            return
        }
        
        let alert = UIAlertController(title: "Sell Up to \(stock.sharesOwned) stock\(stock.sharesOwned > 1 ? "s" : "")", message: "Either sell all stocks or enter amount.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Choose Amount", style: .default, handler: { (action) in
            let alert = UIAlertController(title: "Enter amount of stocks to sell", message: "", preferredStyle: .alert)
            var textField: UITextField!
            alert.addTextField(configurationHandler: { (field) in
                field.keyboardType = .numberPad
                textField = field
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Sell", style: .default, handler: { (action) in
                if let amountToSell = Int(textField.text ?? "") {
                    let title: String
                    if amountToSell > self.stock.sharesOwned {
                        title = "You do not have enough of this stock to sell."
                        
                    } else {
                        APIManager.shared.sellStock(identifier: self.stock.ticker, shares: amountToSell, onSuccess: { (transaction) in
                            APIManager.shared.user!.transactions.append(transaction)
                        }, onFailure: { (error) in
                            
                        })
                        title = "You have sold \(amountToSell) stocks earning \((self.stock.currentPrice * Float(amountToSell)).moneyFormat)"
                    }
                    
                    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Sell All", style: .destructive, handler: { (action) in
            
            let amount = APIManager.shared.user!.ownedStocks.filter { $0 == self.stock }.count
            
            APIManager.shared.sellStock(identifier: self.stock.ticker, shares: amount, onSuccess: { (transaction) in
                APIManager.shared.user!.transactions.append(transaction)
            }, onFailure: { (error) in
                
            })
            
            let title = "You have sold \(amount) stocks earning \((self.stock.currentPrice * Float(amount)).moneyFormat)"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.reload()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clickBuy(_ sender: StockOptionButton) {
        let alert = UIAlertController(title: "Buy Stocks", message: "Enter amount to buy.", preferredStyle: .alert)
        var textField: UITextField!
        
        alert.addTextField(configurationHandler: { (field) in
            field.keyboardType = .numberPad
            textField = field
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Buy", style: .default, handler: { (action) in
            if let amountToBuy = Int(textField.text ?? "") {

                if Float(amountToBuy) * self.stock.currentPrice > APIManager.shared.user!.funds {
                    self.showAlert(title: "You do not have enough money to buy this many stocks.")
                } else {
                    self.showAlert(title: "You have bought \(amountToBuy) shares of \(self.stock.ticker) for \((self.stock.currentPrice * Float(amountToBuy)).moneyFormat)")
                    
                    APIManager.shared.buyStock(identifier: self.stock.ticker, shares: amountToBuy, onSuccess: { (transaction) in
                        APIManager.shared.user!.transactions.append(transaction)
                        self.stock.sharesOwned += transaction.shares
                        self.reload()
                    }, onFailure: { (error) in
                        self.showAlert(title: "An error occurred while trying to buy stock.")
                    })
                }
                
            }
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
