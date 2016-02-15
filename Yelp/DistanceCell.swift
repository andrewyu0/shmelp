//
//  DistanceCell.swift
//  Yelp
//
//  Created by Andrew Yu on 2/14/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

protocol DistanceCellDelegate : class {
    func distanceCell(distanceCell: DistanceCell, valueUpdated: Bool)
}

class DistanceCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!

    var delegate: DistanceCellDelegate?
    var switchView: UISwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func setup(delegate: DistanceCellDelegate, labelText: String, initialValue: Bool = false){
        
        self.switchView = UISwitch(frame: CGRectZero)
        
        switchView?.on = initialValue
        setImage()
        distanceLabel.text = "\(labelText) miles"
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
        print("Distance cell switch toggled")
        switchView!.on = !switchView!.on
        setImage()
        delegate?.distanceCell(self, valueUpdated: switchView!.on)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
