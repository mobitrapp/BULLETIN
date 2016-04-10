//
//  NewsImageCollectionViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 10/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class NewsImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    func configureWithImageURL(imageURL: String) {
        if let imageURL = NSURL(string: imageURL) {
            newsImageView.kf_setImageWithURL(imageURL, placeholderImage: UIImage(named: "NewsImagePlaceHolder"))
        }
    }
    
}
