//
//  NewsTitleTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 07/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class NewsTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsUpdatedDate: UILabel!

    
    func configureWithNewsDetail(newsDetail: NewsDetail) {
        newsTitleLabel.text = newsDetail.title.plainText()
        newsUpdatedDate.text = "Updated: \(newsDetail.updatedDate) IST"
        
    }

}
