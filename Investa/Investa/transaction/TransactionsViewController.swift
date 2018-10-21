//
//  TransactionsViewControll.swift
//  Investa
//
//  Created by Nicholas Grana on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

class TransactionsViewController: UITableViewController {
    
    var transactions = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.getUserTransactions(onSuccess: { transactions in
            let t = transactions.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.date < rhs.date
            })
            APIManager.shared.user!.transactions = t
            self.transactions = t
            self.tableView.reloadData()
        }) { error in
            print(error)
        }
        
        title = "Transactions"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.transaction = transactions[indexPath.row]
        
        return cell 
    }
    
}
