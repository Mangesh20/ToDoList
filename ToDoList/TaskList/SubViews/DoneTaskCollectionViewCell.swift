//
//  DoneTaskCollectionViewCell.swift
//  ToDoList
//
//  Created by mangesht on 21/04/23.
//

import UIKit

class DoneTaskCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Add a border radius
        layer.cornerRadius = 8.0
        
        // Add a shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        // Adjust the shadow path to improve performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = AppTheme.CollectionViewCell.backgroundColor
        titleLabel.textColor = AppTheme.Text.subHeadingColor
        titleLabel.font = AppTheme.Text.subHeading
    }
}
