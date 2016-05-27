//
//  APIHistoryViewController.swift
//  APITool
//
//  Created by Zhouboli on 15/11/12.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

protocol APIHistoryViewControllerDelegate
{
    func historyViewController(tableView: UITableView, didSelectRecord record: NSDictionary, atIndexPath indexPath: NSIndexPath)
}

class APIHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var delegate: APIHistoryViewControllerDelegate?
    var tableView: UITableView?
    var records: NSMutableArray?
    
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
        
        //取消按钮
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(APIHistoryViewController.cancelBarbuttonPressed(_:)))
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        let clearBarButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(APIHistoryViewController.clearBarButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = clearBarButton
        
        self.records = NSMutableArray()
        records?.mutableArrayValueForKeyPath("records")
        rac_valuesForKeyPath("records", observer: self)
        
        let recordSignal: RACSignal = self.rac_valuesAndChangesForKeyPath("records", options: NSKeyValueObservingOptions.New, observer: self)
        recordSignal.subscribeNext { (tuple) -> Void in
            if let tup = tuple as? RACTuple
            {
                let arr: NSMutableArray? = tup.first as? NSMutableArray
                self.navigationItem.rightBarButtonItem?.enabled = arr?.count > 0 ? true : false
            }
        }
        
        self.fetchHistoryURLs()
        
//        let validSignal = self.validTableDataRACSignal()
//        validSignal.subscribeNext { (AnyObject) -> Void in
//            self.navigationItem.rightBarButtonItem!.enabled = AnyObject.boolValue
//        }
    }
    
    // MARK: Helpers

    func validTableDataRACSignal() -> RACSignal
    {
        return RACSignal.createSignal { (subscriber) -> RACDisposable! in
            if self.records == nil || self.records?.count == 0
            {
                subscriber.sendNext(false)
            }
            else
            {
                subscriber.sendNext(true)
            }
            subscriber.sendCompleted()
            return nil
        }
    }
    
    func fetchHistoryURLs() -> Void
    {
        //取出历史记录
        let records = APIUtils.readRecordsFromPlist(APIUtils.plistPathForFilename(filename))
        if records != nil && records?.count > 0
        {
            self.records = NSMutableArray(array: records!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView?.reloadData()
            })
        }
    }
    
    func cancelBarbuttonPressed(sender: UIBarButtonItem)
    {
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            //do something
        })
    }
    
    func clearBarButtonPressed(sender: UIBarButtonItem)
    {
        let ac = UIAlertController(title: "Clear history", message: "Do you want to clear it all?", preferredStyle: UIAlertControllerStyle.Alert)
        let confirmAction = UIAlertAction(title: "Clear", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.records?.removeAllObjects()
            self.records = nil
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                APIUtils.removeAllRecords()
            })
            self.tableView?.reloadData()
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        self.navigationController?.presentViewController(ac, animated: true, completion: { () -> Void in
            
        })
    }
    
    func cleanCell(cell: UITableViewCell)
    {
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.records != nil && self.records?.count > 0
        {
            return (self.records?.count)!
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseId)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        self.cleanCell(cell)
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
        let record = self.records![indexPath.row]
        self.delegate?.historyViewController(tableView, didSelectRecord: record as! NSDictionary, atIndexPath: indexPath)
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            //do sth
        })
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            if APIUtils.deleteRecordAtIndex(indexPath.row)
            {
                self.records?.removeObjectAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            else
            {
                NSLog("删除失败")
            }
        }
    }
    
}