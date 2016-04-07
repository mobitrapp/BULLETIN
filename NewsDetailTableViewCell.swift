//
//  NewsDetailTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 07/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class NewsDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var newsDetailLabel: UILabel!
    @IBOutlet weak var newsPublishedAtLabel: UILabel!

    func configureWithNewsDetail(newsDetail: NewsDetail) {
        newsDetailLabel.text = newsDetail.news.plainText().stringByReplacingOccurrencesOfString("\n", withString: "\n\n")
     
    }
}
