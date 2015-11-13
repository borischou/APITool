//
//  APIHistoryViewController.swift
//  APITool
//
//  Created by Zhouboli on 15/11/12.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit

class APIHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var tableView: UITableView?
    var records: NSArray?
    
    let reuseId = "historycell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "History"
        
        //历史记录表格
        let tvRect = UIScreen.mainScreen().bounds
        self.tableView = UITableView(frame: tvRect, style: UITableViewStyle.Plain)
        self.tableView?.backgroundColor = UIColor.whiteColor()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        self.view.addSubview(self.tableView!)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            //取出历史记录
            self.records = APIUtils.readRecordsFromPlist(APIUtils.plistPathForFilename(filename))
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView?.reloadData()
            })
        }
        
        //取消按钮
        let cancelBarbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelBarbuttonPressed")
        self.navigationItem.leftBarButtonItem = cancelBarbutton
    }
    
    func cancelBarbuttonPressed()
    {
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            //do something
        })
    }
    
    // MARK: Helpers
    
    
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.records != nil && self.records?.count > 0
        {
            return (self.records?.count)!
        }
        else
        {
            return 10
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //let cell = tableView.dequeueReusableCellWithIdentifier("historycell", forIndexPath: indexPath)
        let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseId)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if self.records != nil && self.records?.count > 0
        {
            let record: NSDictionary = self.records![indexPath.row] as! NSDictionary
            cell.textLabel?.text = record["url"] as? String
            cell.detailTextLabel?.text = record["method"] as? String
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    
}