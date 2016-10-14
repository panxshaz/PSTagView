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
//    psTableView.registerClass(PSTagTableCell.self, forCellReuseIdentifier: "PSTagTableCell")
    psTableView.registerNib(UINib(nibName: "PSTagTableCell", bundle: nil), forCellReuseIdentifier: "PSTagTableCell");
    
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
    let cell = tableView.dequeueReusableCellWithIdentifier("PSTagTableCell") as! PSTagTableCell
    cell.tags = tagsArray[indexPath.row % tagsArray.count]    
    return cell
  }
}