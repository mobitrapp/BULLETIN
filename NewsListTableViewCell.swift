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
    
    @IBOutlet weak var postedByLabel: UILabel!
    override func awakeFromNib() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.bulletinLightRed()
        selectedBackgroundView = backgroundView
        
    }
    
    func  configureWithNews(news: News) {
        newsImageView.layer.borderColor = UIColor.grayColor().CGColor
        newsImageView.layer.borderWidth = 0.7
        if postedByLabel != nil {
            postedByLabel.text = ""
            if news.displayPostedBy == "Y" {
                postedByLabel.text = news.postedBy
            }
        }
        
        
        if let imageURL = NSURL(string: news.imageURL) {
            newsImageView.kf_setImageWithURL(imageURL, placeholderImage: UIImage(named: "NewsImagePlaceHolder"))
        } else {
            newsImageView.image = UIImage(named: "NewsImagePlaceHolder")
        }
        
        newsTitleLabel.text = news.title.plainText()
    }
}
