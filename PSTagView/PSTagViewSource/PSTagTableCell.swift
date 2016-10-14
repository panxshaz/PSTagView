//
//  PSTagTableCell.swift
//  PSTagView
//
//  Created by Pankaj Sharma on 12/Oct/16.
//  Copyright © 2016 MarijuanaInc Studio. All rights reserved.
//

import UIKit

public protocol PSTagDelegate {
  func psIsTagIsHighlighted(tagIndex: Int, tagView: PSTagView) -> Bool
  func psTagTapped(tagIndex: Int, tagView: PSTagView)
}

//********************************************************************************//
//******************************* PSTagView **************************************//
//********************************************************************************//
/// Tag View class. Add height constrain and link it to IBOutlet if using inside tableview cell
@IBDesignable public class PSTagView: UIScrollView {
  
  var psTagDelegate: PSTagDelegate?
  
  /// Gap between tags
  var gap: (horizontal: CGFloat, vertical: CGFloat) = (8.0, 8.0)
  
  
  @IBOutlet var psTagViewHeight: NSLayoutConstraint!
  
  /// Whether the TagView should expand according to content. It works in coordination with psTagViewHeight
  /// Default true
  @IBInspectable var dynamicHeight: Bool = true {
    didSet {
      self.scrollEnabled = !dynamicHeight
    }
  }
  
  @IBInspectable var tagFont: UIFont?
  
  override public func awakeFromNib() {
    super.awakeFromNib()
    initialSetUp()
  }
  
  private func initialSetUp() {
    self.translatesAutoresizingMaskIntoConstraints =  false
    self.clipsToBounds = false
    if psTagViewHeight == nil {
      //take frame height
      psTagViewHeight = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.bounds.height)
      
      psTagViewHeight.active = true
      
      //no constraint has been set up. So now you need to calculate your own
      self.scrollEnabled = !dynamicHeight
    }
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initialSetUp()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  private let tagOffset = 101
  
  private func createNewButton(title: String) -> PSTagButton {
    let tagButton = PSTagButton.newInstance(title, font: tagFont)
    //scroll view user interaction are offs
    tagButton.tagActionBlock = { (sender: UIButton) -> Bool in
      self.psTagDelegate?.psTagTapped(sender.tag - self.tagOffset, tagView: self)
      return true
    }
    return tagButton
  }
  
  
  internal func update(tags: [String], constraintToWidth: CGFloat = -1) {
    let rightLimit = (constraintToWidth < 0 ? self.frame.width : constraintToWidth)
    var rect = self.bounds
    rect.size.width = rightLimit
    self.bounds = rect
    print("rightLimit \(rightLimit)")
    //remove existing
    self.subviews.forEach({ $0.removeFromSuperview() })
    
    var prevx: CGFloat = 0.0, prevy: CGFloat = 0.0
    var index = 0
    for tag in tags {
      let buttonTag = tagOffset + index
      let tagButton: PSTagButton!
      if let validTagButton = self.viewWithTag(buttonTag) as? PSTagButton {
        tagButton = validTagButton
      } else {
        tagButton = createNewButton(tag)
        tagButton?.tag = buttonTag
        self.addSubview(tagButton)
      }
      if let shouldBeHighlighted = self.psTagDelegate?.psIsTagIsHighlighted(buttonTag, tagView: self) {
        tagButton?.selected = shouldBeHighlighted
      } else {
        tagButton?.selected = false
      }
      
      var tagButtonBounds = tagButton.bounds
      
      tagButtonBounds.size.width += tagButton.tagInsets.left + tagButton.tagInsets.right
      
      //check if space available in this line
      if (tagButtonBounds.size.width + prevx + gap.horizontal) > rightLimit {
        //next line
        prevx = 0
        prevy += tagButtonBounds.height + gap.vertical
      }
      
      tagButtonBounds.origin = CGPointMake(prevx, prevy)
      tagButton.frame = tagButtonBounds
      psTagViewHeight?.constant = CGRectGetMaxY(tagButtonBounds)
      prevx += tagButtonBounds.size.width + gap.horizontal
      index += 1
    }
    
    if let validSuperview = self.superview, validHeightConstraint = self.psTagViewHeight {
      self.contentSize = CGSizeMake(validSuperview.frame.width - self.frame.origin.x, validHeightConstraint.constant)
    }
    
    print("psTagViewHeight.constant \(psTagViewHeight?.constant)\npsTagView.contentSize : \(self.contentSize)")
  }
  
}

//MARK:
//********************************************************************************//
//******************************* PSTagTableCell *********************************//
//********************************************************************************//
@IBDesignable public class PSTagTableCell: UITableViewCell {
  
  /// Assuming it will start from some position x and will expand till the end of the contentView
  @IBOutlet var psTagView: PSTagView!
  
  /**
   Registers Nib for `tableView`
   
   - parameter tableView:     For what table should it be registered
   - parameter forIdentifier: Default is "PSTagTableCell"
   
   - returns: UINib Object
   */
  public class func registerNib(tableView: UITableView, forIdentifier identifier: String = "PSTagTableCell") -> UINib {
    /// Register nib
    let bundle = NSBundle(forClass: self)
    let nib = UINib(nibName: "PSTagTableCell", bundle: bundle)
    tableView.registerNib(nib, forCellReuseIdentifier: identifier)
    
    return nib
  }
  
  override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    //init psTagView
    var contentViewBounds = self.contentView.bounds
    contentViewBounds.origin.x += 8
    contentViewBounds.origin.y += 8
    //    contentViewBounds.size.width -= 8 * 2
    //    contentViewBounds.size.height -= 8 * 2
    psTagView = PSTagView(frame: self.contentView.bounds)
    //    psTagView.layer.borderWidth = 2
    self.contentView.addSubview(psTagView)
    let topConstraint = NSLayoutConstraint(item: psTagView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.TopMargin, multiplier: 1, constant: 0)
    let bottomConstraint = NSLayoutConstraint(item: psTagView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    let startConstraint = NSLayoutConstraint(item: psTagView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
    let endConstraint = NSLayoutConstraint(item: psTagView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
    
    self.contentView.addConstraints([topConstraint, bottomConstraint, startConstraint, endConstraint])
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public var tags = [String]() {
    didSet {
      psTagView?.update(tags)
    }
  }
  
  
  @IBInspectable public var selectable: Bool = true {
    didSet {
      if psTagView == nil {
        return
      }
      
      for subview in psTagView.subviews {
        subview.userInteractionEnabled = selectable
      }
    }
  }
  
  override public func systemLayoutSizeFittingSize(targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
    var size = super.systemLayoutSizeFittingSize(targetSize, withHorizontalFittingPriority: UILayoutPriorityFittingSizeLevel, verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
    psTagView?.update(tags, constraintToWidth: self.contentView.bounds.width - psTagView.frame.origin.x)
    size.height = psTagView.psTagViewHeight!.constant + (psTagView.frame.origin.y * 2)
    print("systemLayoutSizeFittingSize : \(size)")
    return size
  }
}