//
//  ViewController.swift
//  APITool
//
//  Created by Zhouboli on 15/11/10.
//  Copyright © 2015年 Boris. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, APIMethodURLTableHeaderViewDelegate
{
    var tableView: UITableView?
    var sendButton: UIButton?
    var headerView: APIMethodURLTableHeaderView?
    var rowNumber: NSInteger?
    
    let sendButtonHeight: CGFloat = 60.0
    let headerViewHeight: CGFloat = 200.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "API Tool"
        
        self.rowNumber = 3
        
        let headerRect = CGRectMake(0, (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.size.width, headerViewHeight)
        self.headerView = APIMethodURLTableHeaderView(frame: headerRect)
        self.headerView?.delegate = self
        self.headerView?.urlTextField?.delegate = self
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
        self.sendButton?.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        self.sendButton?.setTitle("SEND", forState: UIControlState.Normal)
        self.sendButton?.enabled = false
        self.sendButton?.addTarget(self, action: "sendButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.sendButton!)
    }
    
    //MARK: UITableView delegate & data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        tableView.registerClass(APIParameterTableViewCell.self, forCellReuseIdentifier: "paramcell")
        let cell = tableView.dequeueReusableCellWithIdentifier("paramcell", forIndexPath: indexPath) as! APIParameterTableViewCell
        cell.keyTextField?.delegate = self
        cell.valueTextField?.delegate = self
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.rowNumber!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50
    }
    
    // MARK: APIMethodURLTableHeaderViewDelegate
    
    func APIMethodURL(tableHeaderView: APIMethodURLTableHeaderView, didTapMethod methodLabel: UILabel)
    {
        let alertcontroller = UIAlertController(title: "Method", message: "Please select a type", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let getac = UIAlertAction(title: "GET", style: UIAlertActionStyle.Default) { (action) -> Void in
            NSLog("GET")
            self.headerView?.methodLabel?.text = "GET"
        }
        let postac = UIAlertAction(title: "POST", style: UIAlertActionStyle.Default) { (action) -> Void in
            NSLog("POST")
            self.headerView?.methodLabel?.text = "POST"
        }
        let cancelac = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            //do something
        }
        alertcontroller.addAction(getac)
        alertcontroller.addAction(postac)
        alertcontroller.addAction(cancelac)
        self.navigationController?.presentViewController(alertcontroller, animated: true, completion: { () -> Void in
            //do something
        })
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.detecteTextField(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        self.detecteTextField(textField)
    }
    
    // MARK: Helpers
    
    func detecteTextField(textField: UITextField)
    {
        textField.layer.borderWidth = 0.5
        
        if textField.text?.characters.count < 1
        {
            textField.layer.borderColor = UIColor.redColor().CGColor
        }
        else
        {
            textField.layer.borderColor = UIColor.greenColor().CGColor
        }
        
        if self.headerView?.urlTextField?.text?.characters.count < 1
        {
            self.sendButton?.enabled = false
            self.headerView?.urlTextField?.layer.borderColor = UIColor.redColor().CGColor
        }
        else
        {
            self.sendButton?.enabled = true
            self.headerView?.urlTextField?.layer.borderColor = UIColor.greenColor().CGColor
        }
    }
    
    func sendButtonPressed()
    {
        if self.headerView?.urlTextField?.text?.characters.count < 1
        {
            return
        }
        
        let urlstr = self.assembleURL()
        let request = self.assembleNSURLRequest(urlstr as String)
        
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { (data, response, responseError) -> Void in
            //do something
            NSLog("data: \(data)\nresponse: \(response)\nerror: \(responseError)")
            let resultvc = APIResultViewController()
            if responseError == nil
            {
                let dataString = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                resultvc.result = NSString.init(format: "DATA: \(dataString!)\n\nRESPONSE: \((response?.description)!)")
            }
            else
            {
                resultvc.result = responseError?.description
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.navigationController?.pushViewController(resultvc, animated: true)
            })
        }.resume()
    }
    
    func assembleURL() -> NSString
    {
        let params: NSMutableDictionary = NSMutableDictionary()
        for index in 0...(self.rowNumber! - 1)
        {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell = self.tableView?.cellForRowAtIndexPath(indexPath) as! APIParameterTableViewCell
            if cell.keyTextField?.text?.characters.count < 1 || cell.valueTextField?.text?.characters.count < 1
            {
                continue
            }
            else
            {
                params.setValue((cell.valueTextField?.text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " ")))!,
                    forKey: (cell.keyTextField?.text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " ")))!)
            }
        }
        NSLog("params: \(params)\nmethod: \(self.headerView?.methodLabel?.text)")
        
        var urlstr: NSString?
        
        if self.headerView?.urlTextField?.text?.hasPrefix("http") != false
        {
            urlstr = (self.headerView?.urlTextField?.text)! + "?"
        }
        else
        {
            urlstr = "https://" + (self.headerView?.urlTextField?.text)! + "?"
        }
        
        for key in params.allKeys
        {
            if key.isEqual(params.allKeys.first) == true //第一个参数不加&
            {
                urlstr = urlstr!.stringByAppendingFormat("\(key)=\((params.valueForKey(key as! String))!)")
            }
            else
            {
                urlstr = urlstr!.stringByAppendingFormat("&\(key)=\((params.valueForKey(key as! String))!)")
            }
        }
        
        if urlstr?.hasSuffix("?") == true
        {
            urlstr?.stringByReplacingOccurrencesOfString("?", withString: "")
        }
        
        return (urlstr?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " ")).stringByReplacingOccurrencesOfString(" ", withString: ""))!
    }
    
    func assembleNSURLRequest(url: String) -> NSURLRequest
    {
        let request = NSMutableURLRequest(URL: NSURL(string: url as String)!)
        NSLog("\((self.headerView?.methodLabel?.text)! as String)")
        request.HTTPMethod = (self.headerView?.methodLabel?.text)! as String
        request.timeoutInterval = 60
        request.allHTTPHeaderFields = nil
        return request as NSURLRequest
    }
}

