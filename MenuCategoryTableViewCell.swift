//
//  MenuCategoryTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 17/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class MenuCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var cellStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.bulletinLightRed()
        selectedBackgroundView = backgroundView
        
    }
    
    func configureWithCategoryDetail(category: Category, cellIsOpen: Bool) {
        categoryNameLabel.text = category.name
        if let categoryIcon = UIImage(named: category.name) {
            categoryIconImageView.image = categoryIcon
            if category.subCategories != nil {
                cellStatusImageView.image = cellIsOpen ? UIImage(named: "Minus")! : UIImage(named: "Plus")!
            } else {
                cellStatusImageView.image = UIImage()
            }
        }
    }
}
