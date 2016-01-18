//
//  MenuSuBCategoryTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 17/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class MenuSubCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var subCategoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.bulletinLightRed()
        selectedBackgroundView = backgroundView
    }
    
    func configureWithSubCategoryDetail(subcategoryDetail: SubCategory) {
        subCategoryNameLabel.text = subcategoryDetail.name
    }
    
}
