//
//  PSHighlightButton.swift
//  SkoolSlate
//
//  Created by Pankaj Sharma on 13/Oct/16.
//  Copyright © 2016 marijuanaincstudios. All rights reserved.
//

import UIKit


typealias PSButtonStateConfig = (background: UIColor, textColor: UIColor?)

//********************************************************************************//
//******************************* PSHighlightButton ******************************//
//********************************************************************************//
@IBDesignable class PSHighlightButton: UIButton {
  
  private var normalBGColor = UIColor.whiteColor() {
    didSet {
      if !self.highlighted && !self.selected {
        self.backgroundColor = normalBGColor
      }
    }
  }
  
  
  private var highlightedBGColor = UIColor ( red: 0.0, green: 0.4784, blue: 1.0, alpha: 1.0 ) {
    didSet {
      if self.highlighted {
        self.backgroundColor = highlightedBGColor
      }
    }
  }
  
  private var selectedBGColor = UIColor ( red: 0.0, green: 0.4784, blue: 1.0, alpha: 1.0 ) {
    didSet {
      if self.selected {
        self.backgroundColor = selectedBGColor
      }
    }
  }
  
  @IBInspectable var normalState: PSButtonStateConfig  {
    get {
      return (textColor: self.titleColorForState(.Normal), background: normalBGColor)
    } set {
      self.normalBGColor = newValue.background
      self.setTitleColor(newValue.textColor, forState: .Normal)
    }
  }
  
  
  @IBInspectable var highlightState: PSButtonStateConfig  {
    get {
      return (textColor: self.titleColorForState(.Highlighted), background: highlightedBGColor)
    } set {
      self.highlightedBGColor = newValue.background
      self.setTitleColor(newValue.textColor, forState: .Highlighted)
    }
  }
  
  var selectedState: PSButtonStateConfig  {
    get {
      return (textColor: self.titleColorForState(.Selected), background: highlightedBGColor)
    } set {
      self.selectedBGColor = newValue.background
      self.setTitleColor(newValue.textColor, forState: .Selected)
    }
  }
  
  
  override var highlighted: Bool {
    didSet {
      if selected {
        self.backgroundColor = selectedBGColor
        return
      }
      self.backgroundColor = highlighted ? highlightedBGColor : normalBGColor
    }
  }
  
  override var selected: Bool {
    didSet {
      self.backgroundColor = selected ? selectedBGColor : normalBGColor
    }
  }
  
  
  convenience init(frame: CGRect, title: String,
                   normalState: PSButtonStateConfig,
                   highlightedState: PSButtonStateConfig) {
    self.init(frame: frame, title: title, normalState: normalState, highlightedState: highlightedState, selectedState: highlightedState)
  }
  
  init(frame: CGRect, title: String,
       normalState: PSButtonStateConfig,
       highlightedState: PSButtonStateConfig,
       selectedState: PSButtonStateConfig) {
    
    super.init(frame: frame)
    let button = self
    button.normalState = normalState
    button.highlightState = highlightedState
    button.selectedState = selectedState
    button.setTitle(title, forState: .Normal)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

//********************************************************************************//
//******************************* PSTagButton ************************************//
//********************************************************************************//
typealias LayerProperties = (width: CGFloat, color: UIColor, corner: CGFloat)

/// Action block; Return true to cancel the tag state switch; By Default it will toggle b/w highlighted and normal state
typealias PSTagActionBlock = (sender: UIButton) -> Bool

@IBDesignable class PSTagButton: PSHighlightButton {
  
  var tappable: Bool {
    get {
      return self.userInteractionEnabled
    } set {
      self.userInteractionEnabled = newValue
    }
  }
  
  var tagInsets: UIEdgeInsets {
    get {
      return self.contentEdgeInsets
    } set {
      self.contentEdgeInsets = newValue
    }
  }
  
  /// Only one target will be allowed
  var tagActionBlock: PSTagActionBlock? {
    didSet {
      addTarget(self, action: #selector(tagButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
    }
  }
  
  private var addedSelfAsTarget = false
  
  override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
    //don't add any external target
    guard let validTarget = target as? PSTagButton
      else {
        NSException(name:"Not Allowed", reason:"Use `tagActionBlock` instead", userInfo:nil).raise()
        return
    }
    
    if addedSelfAsTarget {
      return
    }
    
    super.addTarget(validTarget, action: action, forControlEvents: controlEvents)
    addedSelfAsTarget = true
  }
  
  
  func tagButtonTapped() {
    if let validActionBlock = tagActionBlock {
      let shouldToggleState = validActionBlock(sender: self)
      if shouldToggleState {
        self.selected = !self.selected
      }
    }
  }
  
  
  /**
   Border & Radius properties
   (borderWidth, borderColor, cornerRadius)
   */
  var layerProperties: LayerProperties {
    get {
      
      return (width: self.layer.borderWidth, color: UIColor(CGColor: self.layer.borderColor!), corner: self.layer.cornerRadius)
    } set {
      self.layer.borderWidth = newValue.width
      self.layer.borderColor = newValue.color.CGColor
      self.layer.cornerRadius = newValue.corner
    }
  }
  

  
  /**
   Creates a new instance
   
   - parameter title:            title for the tag
   - parameter tagNormalState:   normal state properties
   - parameter tagSelectedState: highlighted and selected state properties
   - parameter font:             Font for Tag
   - parameter tappable:         Whether the button is tappable or not
   - parameter tagInsets:        Space from all corder to tag button
   
   - returns: New Instance of the button
   */
  class func newInstance(title: String,
                         font: UIFont? = nil,
                         tagNormalState: PSButtonStateConfig = (background: UIColor.whiteColor(), textColor: UIColor.blackColor()),
                         tagSelectedState: PSButtonStateConfig = (background: UIColor ( red: 0.0, green: 0.4784, blue: 1.0, alpha: 1.0 ), textColor: UIColor.whiteColor()),
                         tappable: Bool = true,
                         tagInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)) -> PSTagButton {
    let tagButton = PSTagButton(frame: CGRectZero, title: title, normalState: tagNormalState, highlightedState: tagSelectedState)
    tagButton.tagInsets = tagInsets
    tagButton.layerProperties = (width: 0.3, color: UIColor.blackColor(), corner: 10)
    tagButton.tappable = tappable
    if let validFont = font {
      tagButton.titleLabel?.font = validFont
    }
    
    tagButton.sizeToFit()
    return tagButton
  }
}