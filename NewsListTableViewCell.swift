//
//  NewsListTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 15/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var publishedOnLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    func  configureWithNews(news: News) {
        newsImageView.layer.borderColor = UIColor.grayColor().CGColor
        newsImageView.layer.borderWidth = 0.7
        newsImageView.kf_setImageWithURL(NSURL(string: news.imageURL)!, placeholderImage: UIImage(named: "NewsImagePlaceHolder"))
        newsTitleLabel.text = news.title.plainText()
    }
}
