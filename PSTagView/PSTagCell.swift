//
//  PSTagCell.swift
//  PSTagView
//
//  Created by Pankaj Sharma on 7/Oct/16.
//  Copyright © 2016 MarijuanaInc Studio. All rights reserved.
//

import UIKit

class PSTagCell: UICollectionViewCell {
  @IBOutlet weak var tagButton: UIButton! {
    didSet {
      tagButton.layer.cornerRadius = CGFloat((Int(tagButton.bounds.height * 0.1)))
      tagButton.layer.borderColor = UIColor.blackColor().CGColor
      tagButton.layer.borderWidth = 0.3
    }
  }
  
  private var tagButtonPrivate: UIButton!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    updateView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
//    fatalError("init(coder:) has not been implemented")
  }
  
  func updateTitle(newTitle: String) {
    if tagButton != nil {
      self.tagButton.setTitle(newTitle, forState: .Normal)
    }
  }
  
  private func updateView() {
    if tagButton == nil {
      tagButtonPrivate = UIButton(frame: self.contentView.bounds)
      tagButtonPrivate.setTitleColor(UIColor.blackColor(), forState: .Normal)
      tagButtonPrivate.addTarget(self, action: #selector(tagTapped(_:)), forControlEvents: .TouchUpInside)

//      tagButtonPrivate
      self.contentView.addSubview(tagButtonPrivate)
      let leading = NSLayoutConstraint.init(item: tagButtonPrivate, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
      
      let trailing = NSLayoutConstraint.init(item: tagButtonPrivate, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)

      
      let top = NSLayoutConstraint.init(item: tagButtonPrivate, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)

      
      let bottom = NSLayoutConstraint.init(item: tagButtonPrivate, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      leading.active = true
      trailing.active = true
      top.active = true
      bottom.active = true
      
//      tagButtonPrivate.frame = self.contentView.bounds
      self.tagButton = tagButtonPrivate
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //    self.layer.cornerRadius = tagButton.bounds.width * 0.1
//    self.layer.borderColor = UIColor.redColor().CGColor
//    self.layer.borderWidth = 1.0

  }
  
  @IBAction func tagTapped(sender: UIButton) {
    sender.selected = !sender.selected
    sender.backgroundColor = sender.selected ? UIColor ( red: 0.0, green: 0.4784, blue: 1.0, alpha: 1.0 ) : UIColor.whiteColor()
  }
  
  override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
////    print("count \(PSTagCell.count++)");
    let lattribs = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
////    let requiredWidth: CGFloat = 100;//self.tagButton.currentTitle!.heightWithConstrainedWidth(self.bounds.width, font: self.tagButton.titleLabel!.font)
////    layoutAttributes.size = CGSizeMake(requiredWidth, 50)
    lattribs.size.width += 10
//  lattribs.size.width = self.tagButton.currentTitle!.widthWithConstrainedHeight(150, font: self.tagButton.titleLabel!.font)  + 10
    print("Cell layoutAttributes.Frame \(lattribs.frame)")
    return lattribs
  }
}

//Refer: http://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift
extension String {
  
  func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
    let constraintSize = CGSize(width: width, height: 500.0)
    let boundingBox = (self as NSString).boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
     return boundingBox.height
  }
  
  
  func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
    let constraintSize = CGSize(width: 500.0, height: height)
    let boundingBox = (self as NSString).boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    return boundingBox.width
  }
  
}


//and also on NSAttributedString (which is very useful at times)
//extension NSAttributedString {
//  func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
//    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
//    
//    return boundingBox.height
//  }
//  
//  func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
//    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
//    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
//    
//    return boundingBox.width
//  }
//}

