//
//  PSTagTableCell.swift
//  PSTagView
//
//  Created by Pankaj Sharma on 12/Oct/16.
//  Copyright © 2016 MarijuanaInc Studio. All rights reserved.
//

import UIKit
class PSTagTableCell: UITableViewCell {
  
  //  @IBOutlet weak var psTagView: PSTagView!
  @IBOutlet weak var psTagView: UIScrollView! {
    didSet {
      psTagView.scrollEnabled = false
      //      psTagView.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: -40 )
    }
  }
  @IBOutlet weak var psTagViewHeight: NSLayoutConstraint!
  
  var tags = [String]() {
    didSet {
      updateViews(psTagView.frame.width, removeExisting: true)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  //  override func layoutSubviews() {
  //    super.layoutSubviews()
  //    updateViews(psTagView.frame.width)
  //  }
  //
  private func createNewButton(title: String) -> UIButton {
    let tagButton = UIButton(frame: CGRectZero)
    tagButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    tagButton.addTarget(self, action: #selector(tagTapped(_:)), forControlEvents: .TouchUpInside)
    tagButton.backgroundColor = UIColor.whiteColor()
    tagButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    tagButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
    
    //      tagButton.addTarget(self, action: #selector(tagTapped(_:)), forControlEvents: .TouchUpInside)
    tagButton.layer.cornerRadius = 10
    tagButton.layer.borderColor = UIColor.blackColor().CGColor
    tagButton.layer.borderWidth = 0.3
    tagButton.setTitle(title, forState: .Normal)
    return tagButton
  }
  
  func updateViews(rightLimit: CGFloat, removeExisting: Bool = false) {
    print("rightLimit \(rightLimit)")
    
    if removeExisting {
      for subview in psTagView.subviews {
        subview.removeFromSuperview()
      }
    }
    var prevx: CGFloat = 0.0, prevy: CGFloat = 0.0
    var buttonTag = 101
    for tag in tags {
      var tagButton = psTagView.viewWithTag(buttonTag)
      if tagButton == nil {
        tagButton = createNewButton(tag)
        tagButton?.tag = buttonTag
        psTagView.addSubview(tagButton!)
      }
      tagButton!.sizeToFit()
      
      var frame = tagButton!.bounds
      
      frame.size.width += 8 // 8 for edge insets
      
      //check if space available in this line
      if frame.size.width + prevx + 4 > rightLimit {
        //next line
        prevx = 0
        prevy += 50
      }
      
      frame.origin.x = prevx
      frame.origin.y = prevy
      tagButton!.frame = frame
      psTagViewHeight.constant = CGRectGetMaxY(frame)
      prevx += frame.size.width + 4
      buttonTag += 1
    }
    //    psTagViewHeight.constant = prevy + 50
    
    print("psTagViewHeight.constant \(psTagViewHeight.constant)")
    
  }
  
  @IBAction func tagTapped(sender: UIButton) {
    sender.selected = !sender.selected
    sender.backgroundColor = sender.selected ? UIColor ( red: 0.0, green: 0.4784, blue: 1.0, alpha: 1.0 ) : UIColor.whiteColor()
  }
}