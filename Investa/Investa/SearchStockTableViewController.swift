//
//  SearchStockTableViewController.swift
//  Investa
//
//  Created by Cameron Bennett on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

var loaded = false

class SearchStockTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    var allStocks = [Stock]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        
        var i = 0
        
        if loaded == false {
            let _ = ["MU", "AMD", "TSLA", "AAPL", "GOOG", "ROPE", "AMZN", "MSFT"].map {
                
                APIManager.shared.getStock(identifier: $0, onSuccess: { (stock) in
                    if stock.history.isEmpty {
                        return
                    }
                    
                    loaded = true
                    
                    stock.currentPrice = stock.history.last!.price
                    self.allStocks.append(stock)
                    
                    if i % 2 == 0 {
                        self.trending.append(stock)
                    } else {
                        self.recommended.append(stock)
                    }
                    
                    i += 1
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }, onFailure: { (error) in
                    
                })
            }
        }
       
        
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    var trending = [Stock]()
    
    var recommended = [Stock]()

    
    var filtered = [Stock]()
    
    var isSearching = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        filtered = allStocks
        
        tableView.register(UINib(nibName: "SearchStockCell", bundle: nil), forCellReuseIdentifier: "SearchStockCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search stocks"
        searchController.searchBar.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filtered.count
        }
        
        if section == 0 {
            return trending.count
        } else {
            return recommended.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchStockCell", for: indexPath) as! SearchStockCell

        if isSearching {
            cell.stock = filtered[indexPath.row]
        } else {
            if indexPath.section == 0   {
                cell.stock = trending[indexPath.row]
            } else {
                cell.stock = recommended[indexPath.row]
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchStockCell {
            let stock: Stock = cell.stock

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "Stock") as? StockViewController {
                navigationController?.pushViewController(viewController, animated: true)
                viewController.stock = stock
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }else{
            isSearching = true
            filtered = allStocks.filter { user in
                return user.ticker.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching{
            return "Search Results"
        }
        if section == 0{
            return "Hot Stocks"
        }else{
            return "Recommended"
        }
    }

}
