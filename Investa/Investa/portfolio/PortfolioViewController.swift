//
//  PortfolioViewController.swift
//  Investa
//
//  Created by Nicholas Grana on 10/19/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit
import Charts

class PortfolioViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var transactions = [Transaction]()
    
    var user: User! {
        return APIManager.shared.user!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "GraphHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GraphHeaderView")
        collectionView.register(UINib(nibName: "PortfolioGraphCell", bundle: nil), forCellWithReuseIdentifier: "PortfolioGraphCell")
        collectionView.register(UINib(nibName: "PortfolioStockCell", bundle: nil), forCellWithReuseIdentifier: "PortfolioStockCell")
        
        let _ = ["MU", "AMD", "TSLA", "AAPL", "GOOG", "ROPE", "AMZN", "MSFT"].map {
            APIManager.shared.getStock(identifier: $0, onSuccess: { (stock) in
                if stock.history.isEmpty {
                    return
                }
                
                stock.currentPrice = stock.history.last!.price
                self.user.ownedStocks.append(stock)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }, onFailure: { (error) in
                
            })
        }
        
        APIManager.shared.getUserTransactions(onSuccess: { transactions in
            var stockInfo = [String: Int]()
            let sortedTransactions = transactions.sorted(by: { $0.getDate()! < $1.getDate()! })
            self.user.transactions = sortedTransactions
            for transaction in sortedTransactions {
                if transaction.type == "BUY" {
                    if stockInfo[transaction.ticker] != nil {
                        stockInfo[transaction.ticker] = transaction.shares + stockInfo[transaction.ticker]!
                    } else {
                        stockInfo[transaction.ticker] = transaction.shares
                    }
                } else {
                    if stockInfo[transaction.ticker] != nil {
                        stockInfo[transaction.ticker] = transaction.shares + stockInfo[transaction.ticker]!
                    } else {
                        stockInfo[transaction.ticker] = transaction.shares
                    }
                }
            }
            for (stock, shares) in stockInfo {
                APIManager.shared.getStock(identifier: stock, shares: shares, onSuccess: { (loadedStock) in
                    if loadedStock.history.isEmpty {
                        return
                    }
                    
                    loadedStock.currentPrice = loadedStock.history.last!.price
                    self.user.ownedStocks.append(loadedStock)
                    print(loadedStock)
                    self.collectionView.reloadData()
                }, onFailure: { (error) in
                    print("Error while loading stocks: \(error)")
                })
            }
        }) { error in
            print("Error while loading transactions: \(error)")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return user.ownedStocks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioGraphCell", for: indexPath) as! PortfolioGraphCell
            cell.stockGraph.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.40)
            cell.stockGraph.setDataCount(20, range: 20)

            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioStockCell", for: indexPath) as! PortfolioStockCell
            
            cell.stock = user.ownedStocks[indexPath.row]
            cell.profile = user
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: view.frame.height * 0.40)
        } else {
            return CGSize(width: view.frame.width * 0.95, height: 63)
        }
        
    }
    
    // MARK:- Headers
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GraphHeaderView", for: indexPath) as! GraphHeaderView
        
        headerView.frame.size.height = 50
        headerView.label.text = indexPath.section == 0 ? "Funds" : "Your Stocks"
        headerView.rightLabel.text = indexPath.section == 0 ? "\(APIManager.shared.user!.funds.moneyFormat)" : nil
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "Stock") as? StockViewController {
            navigationController?.pushViewController(viewController, animated: true)
            viewController.stock = self.user.ownedStocks[indexPath.row]
        }
    }
    
}
