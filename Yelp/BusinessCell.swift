//
//  BusinessCell.swift
//  Yelp
//
//  Created by Andrew Yu on 2/9/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    
    @IBOutlet weak var thumbImageView    : UIImageView!
    @IBOutlet weak var ratingsImageView  : UIImageView!
    @IBOutlet weak var businessNameLabel : UILabel!
    @IBOutlet weak var addressLabel      : UILabel!
    @IBOutlet weak var distanceLabel     : UILabel!
    @IBOutlet weak var reviewsCountLabel : UILabel!
    @IBOutlet weak var categoriesLabel   : UILabel!
    
    var business : Business! {
        didSet {
            businessNameLabel.text = business.name
            thumbImageView.setImageWithURL(business.imageURL!)
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingsImageView.setImageWithURL(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
