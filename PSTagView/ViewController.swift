//
//  ViewController.swift
//  PSTagView
//
//  Created by Pankaj Sharma on 7/Oct/16.
//  Copyright © 2016 MarijuanaInc Studio. All rights reserved.
//

import UIKit

let TESTING = true

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var psTagView: PSTagView!
  
  @IBOutlet weak var psTableView: UITableView! {
    didSet {
      psTableView.delegate = self
      psTableView.dataSource = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //    let tagView = PSTagView.newInstance()
    //    tagView.backgroundColor = UIColor.greenColor()
    //    self.view.addSubview(tagView)
    //    tagView.frame = self.view.bounds
    //    psTagView = tagView
    
    psTableView.rowHeight = UITableViewAutomaticDimension
    psTableView.estimatedRowHeight = 50
    
  }
  
  let tagsArray = [["0. Whatever come", "One"],
                   ["1. Whatever it may come", "One", "Two", "Three", "Hundred", "Once upon", "a", "time",  "in Africa", "Created by Pankaj", "Sharma on", "7/Oct/16", "Copyright © 2016", "MarijuanaInc Studio", "All rights reserved"],
                   ["2. Created by Pankaj", "Sharma on", "7/Oct/16", "Copyright © 2016", "MarijuanaInc Studio", "All rights reserved"],
                   ["3. Three", "Hundred", "Once upon", "a", "time",  "in Africa", "Created by Pankaj", "Sharma on", "7/Oct/16", "Copyright © 2016", "MarijuanaInc Studio", "All rights reserved"],
                   ["4. Whatever it may come", "One"],
                   ["5. Just", "like", "that", "I", "stopped", "talkingss"]];
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if TESTING {
      //      self.psTagView.tags = ["Whatever it may come", "One", "Two", "Three", "Hundred", "Once upon", "a", "time",  "in Africa", "Created by Pankaj", "Sharma on", "7/Oct/16", "Copyright © 2016", "MarijuanaInc Studio", "All rights reserved"];
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tagsArray.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PSTableCell") as! PSTableCell
    cell.tags = tagsArray[indexPath.row % tagsArray.count]
    cell.updateViews(tableView.frame.width)
    return cell
  }
}



class PSTableCell: UITableViewCell {
  
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
  
  private func updateViews(rightLimit: CGFloat, removeExisting: Bool = false) {
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

