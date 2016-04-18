//
//  NewsImagesTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 10/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class NewsImagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsPageControl: UIPageControl!
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
        newsPageControl.numberOfPages = imagesURL.count
        return imagesURL.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("newsImageCollectionViewCell", forIndexPath: indexPath)
        (collectionViewCell as? NewsImageCollectionViewCell)?.configureWithImageURL(imagesURL[indexPath.row])
        return collectionViewCell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageToBeSelected = lround(Double(scrollView.contentOffset.x / scrollView.bounds.size.width))
        newsPageControl.currentPage = pageToBeSelected
    }
}

extension NewsImagesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: contentView.bounds.width, height: imagesCollectionView.bounds.height)
    }
}


extension NewsImagesTableViewCell {
    
    @IBAction func pageControlValueChanged(sender: AnyObject) {
        let x = CGFloat(newsPageControl.currentPage) * imagesCollectionView.frame.size.width
        if x >= 0 && x <= imagesCollectionView.contentSize.width {
            imagesCollectionView.setContentOffset(CGPoint(x: x, y: 0.0), animated: true)
        }
    }
}
