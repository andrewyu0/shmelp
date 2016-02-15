//
//  DealCell.swift
//  Yelp
//
//  Created by Andrew Yu on 2/13/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

@objc protocol DealCellDelegate : class {
    optional func dealCell(dealCell: DealCell, didUpdateValue: Bool)
}

class DealCell: UITableViewCell {

    var delegate: DealCellDelegate?

    @IBOutlet weak var dealSwitch: UISwitch!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    @IBAction func dealToggled(sender: UISwitch) {
        delegate?.dealCell?(self, didUpdateValue: sender.on)
    }
    
    func setup(delegate: DealCellDelegate, state: Bool = false){
        self.delegate = delegate
        dealSwitch.on = state
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
