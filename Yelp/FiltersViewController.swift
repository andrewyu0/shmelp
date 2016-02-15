//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Andrew Yu on 2/10/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: NSDictionary)
}

class FiltersViewController:
    UIViewController, UITableViewDataSource, UITableViewDelegate,
    SwitchCellDelegate, DealCellDelegate, SortCellDelegate, DistanceCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String:String]]!
    var switchStates = [Int: Bool]()
    
    let dealText     = "Offers Deals"
    let sortText     = "Sort By"
    let distanceText = "Distance"
    let categoryText = "Categories"
    let seeAllText   = "See All"
    let collapseText = "Collapse"
    
    let sections  = ["Offers Deals", "Sort By", "Distance", "Categories"]
    let sorts     = ["Best Match", "Distance", "Highest Ratings"]
    let distances = ["5", "2", "1"]
    
    var selectedSort     = 0
    var selectedDistance = 0
    let metersPerMile    = 1609
    
    var filterByDeals = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Filter Dictionary, to be used in other VC
    var filters: NSDictionary {

        get {
            let filters = NSMutableDictionary()
            
            // CATEGORIES
            var selectedCategories = [String]()
            for (row, isSelected) in switchStates {
                if isSelected {
                    selectedCategories.append(categories[row]["code"]!)
                }
            }
            if selectedCategories.count  > 0 {
                filters["categories"] = selectedCategories
            }
            // Deals, Sort, Radius (distance)
            filters.setValue(filterByDeals, forKey: "deals_filter")
            filters.setValue(selectedSort, forKey: "sort")
            filters.setValue(Int(distances[selectedDistance])! * metersPerMile, forKey: "radius_filter")

            return filters
        }
        
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    
    // MARK: - set up TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionsArr = sections as NSArray
        
        switch section {
        case sectionsArr.indexOfObject(categoryText):
            return categories.count
        case sectionsArr.indexOfObject(sortText):
            return sorts.count
        case sectionsArr.indexOfObject(dealText):
            return 1
        case sectionsArr.indexOfObject(distanceText):
            return distances.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionsArr = sections as NSArray
        
        switch indexPath.section {
        case sectionsArr.indexOfObject(categoryText):
            return getCategoryCell(indexPath)
        case sectionsArr.indexOfObject(sortText):
            return getSortCell(indexPath)
        case sectionsArr.indexOfObject(dealText):
            return getDealCell()
        case sectionsArr.indexOfObject(distanceText):
            return getDistanceCell(indexPath)
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Allow for toggle switch
        if(indexPath.section == 1){
            (tableView.cellForRowAtIndexPath(indexPath)! as! SortCell).toggleSwitch()
        }
        if(indexPath.section == 2){
            (tableView.cellForRowAtIndexPath(indexPath)! as! DistanceCell).toggleSwitch()
        }
        
    }

    
    // MARK: - TableViewCell Helpers

    func getSortCell(indexPath: NSIndexPath) -> SortCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SortCell") as! SortCell
        cell.setup(self, labelText: sorts[indexPath.row], initialValue: selectedSort == indexPath.row)
        return cell
    }
    
    func getDistanceCell(indexPath: NSIndexPath) -> DistanceCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DistanceCell") as! DistanceCell
        cell.setup(self, labelText: distances[indexPath.row], initialValue: selectedDistance == indexPath.row)
        return cell
    }
    
    func getDealCell() -> DealCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DealCell") as! DealCell
        cell.setup(self, state: filterByDeals)
        cell.delegate = self
        return cell
    }

    
    func getCategoryCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
        // Set state of cell =  If there's already a state, set it to that bool val ?? otherwise, set to a default state
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        
        return cell
    }
    
    
    // MARK: - Delegates
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        switchStates[indexPath.row] = value
    }
    
    func dealCell(dealCell: DealCell, didUpdateValue: Bool) {
        filterByDeals = didUpdateValue
    }
    
    func sortCell(sortCell: SortCell, valueUpdated: Bool) {
        selectedSort = tableView.indexPathForCell(sortCell)!.row
        tableView.reloadData()
    }
    
    func distanceCell(distanceCell: DistanceCell, valueUpdated: Bool) {
        selectedDistance = tableView.indexPathForCell(distanceCell)!.row
        tableView.reloadData()
    }
    
    
    // MARK: - yelp category functionality
    
    func yelpCategories() -> [[String:String]]{
      return [
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name" : "Buffets", "code": "buffets"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Korean", "code": "korean"]
        ]
    }
}
