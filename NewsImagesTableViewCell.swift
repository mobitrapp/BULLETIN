//
//  NewsImagesTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 10/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class NewsImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var imagesURL: [String]!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
    }
}


extension NewsImagesTableViewCell: UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURL.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("newsImageCollectionViewCell", forIndexPath: indexPath)
        (collectionViewCell as? NewsImageCollectionViewCell)?.configureWithImageURL(imagesURL[indexPath.row])
        return collectionViewCell
    }
    
}

extension NewsImagesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: contentView.bounds.width, height: imagesCollectionView.bounds.height)
    }
}
