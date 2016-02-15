//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Developed by Andrew Yu starting 2/9/16
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import SVProgressHUD

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchBar      : UISearchBar!
    var businesses     : [Business]!
    var filteredData   : [String]!
    var currentFilters : NSDictionary?

    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Add search bar to navigation
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar!.text = query
        navigationItem.titleView = searchBar
        searchBar.delegate = self

        // set navbar styling
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.translucent  = false
            navigationBar.barTintColor = UIColor.redColor()
            navigationBar.tintColor    = UIColor.whiteColor()
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        SVProgressHUD.show()
        fetchYelpData(query, filters: currentFilters)
    }

    var query: String {
        get {
            if let bar = searchBar {
                return bar.text! == "" ? "Restaurants" : bar.text!
            } else {
                return "Restaurants"
            }
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        Business.searchWithTerm("Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
        })
        self.refreshControl.endRefreshing()
        
    }
    
    func fetchYelpData(query:String, filters: NSDictionary?){
        
        SVProgressHUD.show()
        
        if (filters != nil) {
            let categories = filters!["categories"] as? [String]
            let dealsBool = filters!["deals_filter"] as! Bool
            let radius    = filters!["radius_filter"] as! Double
            var sortOrder = YelpSortMode.BestMatched
            if let sort = filters!["sort"] as? Int {
                sortOrder =  YelpSortMode(rawValue: sort)!
            }
            
            
            Business.searchWithTerm(query, sort: sortOrder, categories: categories, deals: dealsBool, radius: radius){
                (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
        else {
            Business.searchWithTerm(query, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Table View Delegate and DataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        SVProgressHUD.dismiss()
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Search Bar Delegate methods
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        SVProgressHUD.show()
        fetchYelpData(query, filters: currentFilters)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        fetchYelpData(query, filters: currentFilters)
        SVProgressHUD.dismiss()
        
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate  = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: NSDictionary) {
         // Retrigger the data call
        SVProgressHUD.show()
        
        // Set up vals to use in Business.searchWithTerm
        let categories = filters["categories"] as? [String]
        let dealsBool  = filters["deals_filter"] as! Bool
        let radius     = filters["radius_filter"] as! Double
        var sortOrder  = YelpSortMode.BestMatched
        if let sort = filters["sort"] as? Int {
            sortOrder =  YelpSortMode(rawValue: sort)!
        }
        
        Business.searchWithTerm(query, sort: sortOrder, categories: categories, deals: dealsBool, radius: radius){
            (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            self.currentFilters = filters
            SVProgressHUD.dismiss()
        }
    }


}
