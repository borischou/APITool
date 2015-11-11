//
//  ViewController.swift
//  APITool
//
//  Created by Zhouboli on 15/11/10.
//  Copyright © 2015年 Boris. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIMethodURLTableHeaderViewDelegate
{
    var tableView: UITableView?
    var sendButton: UIButton?
    var headerView: APIMethodURLTableHeaderView?
    
    let sendButtonHeight: CGFloat = 60.0
    let headerViewHeight: CGFloat = 200.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "API Tool"
        
        let headerRect = CGRectMake(0, (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.size.width, headerViewHeight)
        self.headerView = APIMethodURLTableHeaderView(frame: headerRect)
        self.headerView?.delegate = self
        self.view.addSubview(self.headerView!)
        
        let tvTop: CGFloat = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.height + headerViewHeight
        let tvRect = CGRectMake(0, tvTop, self.view.frame.size.width, self.view.frame.size.height - sendButtonHeight - tvTop)
        self.tableView = UITableView(frame: tvRect, style: UITableViewStyle.Grouped)
        self.tableView?.backgroundColor = UIColor.lightGrayColor()
        self.tableView?.separatorStyle = .None
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        
        let sendButtonRect = CGRectMake(0, self.view.frame.size.height - sendButtonHeight, self.view.frame.size.width, sendButtonHeight)
        self.sendButton = UIButton(frame: sendButtonRect)
        self.sendButton?.backgroundColor = UIColor.greenColor()
        self.sendButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.sendButton?.setTitle("SEND", forState: UIControlState.Normal)
        self.sendButton?.addTarget(self, action: "sendButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.sendButton!)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        tableView.registerClass(APIParameterTableViewCell.self, forCellReuseIdentifier: "paramcell")
        let cell = tableView.dequeueReusableCellWithIdentifier("paramcell", forIndexPath: indexPath)
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50
    }
    
    func sendButtonPressed()
    {
        
    }
    
    // MARK: APIMethodURLTableHeaderViewDelegate
    func APIMethodURL(tableHeaderView: APIMethodURLTableHeaderView, didTapMethod methodLabel: UILabel)
    {
        let alertcontroller = UIAlertController(title: "Method", message: "Select a method", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let getac = UIAlertAction(title: "GET", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            NSLog("GET")
            self.headerView?.methodLabel?.text = "GET"
        }
        let postac = UIAlertAction(title: "POST", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            NSLog("POST")
            self.headerView?.methodLabel?.text = "POST"
        }
        let cancelac = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            //do something
        }
        alertcontroller.addAction(getac)
        alertcontroller.addAction(postac)
        alertcontroller.addAction(cancelac)
        self.navigationController?.presentViewController(alertcontroller, animated: true, completion: { () -> Void in
            //do something
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

