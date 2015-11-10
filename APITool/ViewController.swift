//
//  ViewController.swift
//  APITool
//
//  Created by Zhouboli on 15/11/10.
//  Copyright © 2015年 Boris. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var tableView: UITableView?
    var sendButton: UIButton?
    let sendButtonHeight: CGFloat = 60.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "API Tool"
        
        let tvRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - sendButtonHeight)
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
        if indexPath.section == 0
        {
            tableView.registerClass(APIMethodTableViewCell.self, forCellReuseIdentifier: "methodcell")
            let cell = tableView.dequeueReusableCellWithIdentifier("methodcell", forIndexPath: indexPath)
            
            
            return cell
        }
        else if indexPath.section == 1
        {
            tableView.registerClass(APIURLTableViewCell.self, forCellReuseIdentifier: "urlcell")
            let cell = tableView.dequeueReusableCellWithIdentifier("urlcell", forIndexPath: indexPath)
            
            return cell
        }
        else
        {
            tableView.registerClass(APIParameterTableViewCell.self, forCellReuseIdentifier: "paramcell")
            let cell = tableView.dequeueReusableCellWithIdentifier("paramcell", forIndexPath: indexPath)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section != 2
        {
            return 1
        }
        else
        {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50
    }
    
    func sendButtonPressed()
    {
        NSLog("sendButtonPressed")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

