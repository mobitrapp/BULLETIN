//
//  SectionTitleTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 15/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class SectionTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionTitle: UILabel!

    func configureWithTitle(title: String) {
        sectionTitle.text = title
    }
    
}
