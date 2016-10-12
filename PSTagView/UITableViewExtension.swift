//
//  UITableViewExtension.swift
//  SkoolSlate
//
//  Created by Pankaj Sharma on 13/Sep/16.
//  Copyright © 2016 marijuanaincstudios. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  
  /**
   Reloads just the view and not the data. Useful for recalculating various table heights
   */
  func reloadJustTheView()  {
    let currentOffset = self.contentOffset
    UIView.setAnimationsEnabled(false)
    self.beginUpdates()
    self.endUpdates()
    UIView.setAnimationsEnabled(true)
    self.setContentOffset(currentOffset, animated: false)
  }
  
  /**
   Dims table if `enabled` is false
   */
  func setInteractionEnabled(enabled: Bool) {
    self.allowsSelection = enabled
    self.scrollEnabled = enabled
    self.alpha = enabled ? 1.0 : 0.8
  }
}