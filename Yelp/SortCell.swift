//
//  SortCell.swift
//  Yelp
//
//  Created by Andrew Yu on 2/13/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

protocol SortCellDelegate : class {
    func sortCell(sortCell: SortCell, valueUpdated: Bool)
}

class SortCell: UITableViewCell {

    @IBOutlet weak var sortLabel: UILabel!
    
    var delegate: SortCellDelegate?
    var switchView: UISwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    func setup(delegate: SortCellDelegate, labelText: String, initialValue: Bool = false){
        
        self.switchView = UISwitch(frame: CGRectZero)
        
        switchView?.on = initialValue
        setImage()
        sortLabel.text = labelText
        self.delegate = delegate
    }
    
    func setImage() {
        if switchView!.on {
            self.accessoryView = UIImageView(image: UIImage(named: "selectedImage"))
        } else {
            self.accessoryView = UIImageView(image: UIImage(named: "deselectedImage"))
        }
    }
    
    func toggleSwitch() {
        print("Sort cell switch toggled")
        switchView!.on = !switchView!.on
        setImage()
        
        delegate?.sortCell(self, valueUpdated: switchView!.on)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
