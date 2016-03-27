//
//  SectionTitleTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 15/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

enum HomeScreenNewsSectionType: Int {
    case TopNews = 0
    case Karnataka
    case Special
}

protocol SectionTitleTableViewCellDelegate {
    func moreButtonTappedForSectionType(sectionType: HomeScreenNewsSectionType)
}


class SectionTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sectionTitle: UILabel!
    var sectionType: HomeScreenNewsSectionType?
    var delegate: SectionTitleTableViewCellDelegate?
    
    func configureWithTitle(title: String, sectionType: HomeScreenNewsSectionType?) {
        sectionTitle.text = title
        self.sectionType = sectionType
    }
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        if let sectionType = sectionType {
            delegate?.moreButtonTappedForSectionType(sectionType)
        }
    }
}
