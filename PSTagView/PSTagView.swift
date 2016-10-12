//
//  PSTagView.swift
//  PSTagView
//
//  Created by Pankaj Sharma on 7/Oct/16.
//  Copyright © 2016 MarijuanaInc Studio. All rights reserved.
//

import UIKit

class PSTagView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet var tagsCVLayout: UICollectionViewFlowLayout!
  
  @IBOutlet weak var tagsCollectionViewHeight: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setUp()
  }
  
  weak var tagsCollectionView: UICollectionView!
  
  private func setUp() {
    tagsCollectionView = self
    tagsCollectionView.scrollEnabled = true
    tagsCollectionView.backgroundColor = UIColor.yellowColor()
    tagsCVLayout.estimatedItemSize = CGSizeMake(50, 44)
    tagsCollectionView.delegate = self
    tagsCollectionView.dataSource = self
  }
  
  
  var tags = [String]() {
    didSet {
      tagsCollectionView.reloadData()
    }
  }
  
  
  //MARK: - UICollectionViewDataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tags.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    guard let tagCell = collectionView.dequeueReusableCellWithReuseIdentifier("PSTagCell", forIndexPath: indexPath) as? PSTagCell else {
      print("Something went wrong!!")
      abort()
    }
    tagCell.updateTitle(tags[indexPath.item])
    
    if indexPath.item == tags.count - 1  {
      //last row
      tagsCollectionViewHeight.constant = CGRectGetMaxY(tagCell.frame) + 20 //self.contentSize.height + 40 //
      print("tagsCollectionViewHeight.constant : \(tagsCollectionViewHeight.constant)")
      self.layoutIfNeeded()
    }
    
    return tagCell;
  }
  
  //MARK: - UICollectionViewDelegate
  
}
