//
//  ScoreboardTableViewController.swift
//  Investa
//
//  Created by Cameron Bennett on 10/19/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

class ScoreboardTableViewController: UITableViewController,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate {

    var leaderboard: [Profile] = []
    
    var filtered = [Profile]()
    
    var isSearching = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.placeholder = "Search leaderboard"
        searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self 
        definesPresentationContext = true
        self.navigationItem.searchController = searchController
        
        addToLeaderboard()
        tableView.delegate = self
        tableView.dataSource = self
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }else{
            isSearching = true
            filtered = leaderboard.filter { user in
                return user.name.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
            print(filtered)
            tableView.reloadData()
        }
    }

    func addToLeaderboard(){
//        let guy1 = User.init( name: "Gill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy1)
//        let guy2 = User.init(name: "Bill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy2)
//        let guy3 = User.init(name: "Bill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy3)
//        let guy4 = User.init( name: "Bill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy4)
//        let guy5 = User.init( name: "Bill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy5)
//        let guy6 = User.init( name: "Bill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy6)
//        let guy7 = User.init( name: "Bill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy7)
//        let guy8 = User.init( name: "Bill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy8)
//        let guy9 = User.init( name: "Bill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy9)
//        let guy10 = User.init( name: "Bill", totalFunds: 1000, percentIncrease: 10000.00)
//        leaderboard.append(guy10)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filtered.count
        } else {
            return leaderboard.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearching{
            let user = filtered[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
            print(indexPath.row)
            cell.rank.text = "\(indexPath.row + 1)" + "."
            cell.pic.image = UIImage(named: "pic" + "\(indexPath.row + 1)")
            cell.name.text = user.name
            cell.totalFunds.text = "\(user.funds)"
//            cell.percentChange.text = "\(user.percentIncrease)"
            cell.pic.layer.cornerRadius = 41
            cell.pic.layer.masksToBounds = true
            cell.pic.clipsToBounds = true
            return cell
        }else{
         
        let user = leaderboard[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        print(indexPath.row)
        cell.rank.text = "\(indexPath.row + 1)" + "."
        cell.pic.image = UIImage(named: "sample")
        cell.name.text = user.name
//        cell.totalFunds.text = "\(user.totalFunds)"
//        cell.percentChange.text = "\(user.percentIncrease)"
        cell.pic.layer.cornerRadius = 41
        cell.pic.layer.masksToBounds = true
        cell.pic.clipsToBounds = true
        return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        tableView.tableFooterView = customView
        let rank = UILabel(frame: CGRect(x: 5, y: customView.frame.height/2-15, width: 50, height: 50))
        rank.font = UIFont(name: "Helvetica Neue", size: 30)
        rank.textColor = .white
        rank.text = "1."
        customView.addSubview(rank)
        let button = UILabel(frame: CGRect(x: customView.frame.width/2-75, y: customView.frame.height/2-25, width: 150, height: 75))
        button.font = UIFont(name: "Helvetica Neue", size: 30)
        button.text = APIManager.shared.user!.name
        button.textColor = .white
        customView.addSubview(button)
        let image = UIImageView(frame: CGRect(x: 35, y: customView.frame.height/2-25, width: 70, height: 70))
        image.image = UIImage(named: "pic4")
        image.layer.cornerRadius = 35
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        customView.addSubview(image)
        return customView
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchController.searchBar.text == nil || searchController.searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }else{
            isSearching = true
            filtered = leaderboard.filter({$0.name == searchController.searchBar.text})
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            // to hide footer for section 0
            return 75
        } else {
            
            return 75
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
