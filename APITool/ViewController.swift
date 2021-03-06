//
//  ViewController.swift
//  APITool
//
//  Created by Zhouboli on 15/11/10.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

let aScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let filename = "records.plist"
let KEY_URL = "url"
let KEY_METHOD = "method"
let KEY_PARAMETERS = "params"

class ViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate,
    APIMethodURLTableHeaderViewDelegate,
    APIHistoryViewControllerDelegate
{
    var tableView: UITableView?
    var sendButton: UIButton?
    var headerView: APIMethodURLTableHeaderView?
    var historyBarbutton: UIBarButtonItem?

    var params: [APIParameter]? //var makes the [dataType] mutable 
                                //NSMutableArray/NSMutableDictionary cannot be implicitly bridged to Swift
    
    let sendButtonHeight: CGFloat = 60.0
    let headerViewHeight: CGFloat = 200.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "API Tool"
        
        self.loadInitParams()
        
        //历史记录
        let historyButton = UIButton(type: UIButtonType.Custom)
        historyButton.frame = CGRectMake(0, 0, 23, 23)
        historyButton.setImage(UIImage(named: "icon_group_tab") , forState: UIControlState.Normal)
        historyButton.addTarget(self, action: #selector(ViewController.historyButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.historyBarbutton = UIBarButtonItem(customView: historyButton)
        self.navigationItem.leftBarButtonItem = self.historyBarbutton
        
        //顶端视图
        let headerRect = CGRectMake(0, (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.size.width, headerViewHeight)
        self.headerView = APIMethodURLTableHeaderView(frame: headerRect)
        self.headerView?.delegate = self
        self.headerView?.urlTextField?.delegate = self
        self.view.addSubview(self.headerView!)
        
        //字典表格
        let tvTop: CGFloat = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.height + headerViewHeight
        let tvRect = CGRectMake(0, tvTop, self.view.frame.size.width, self.view.frame.size.height - sendButtonHeight - tvTop)
        self.tableView = UITableView(frame: tvRect, style: UITableViewStyle.Grouped)
        self.tableView?.backgroundColor = UIColor.lightGrayColor()
        self.tableView?.separatorStyle = .None
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        
        //发送按钮
        let sendButtonRect = CGRectMake(0, self.view.frame.size.height - sendButtonHeight, self.view.frame.size.width, sendButtonHeight)
        self.sendButton = UIButton(frame: sendButtonRect)
        self.sendButton?.backgroundColor = UIColor.greenColor()
        self.sendButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.sendButton?.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        self.sendButton?.setTitle("SEND", forState: UIControlState.Normal)
        self.sendButton?.enabled = false
        self.sendButton?.layer.shadowColor = UIColor.blackColor().CGColor
        self.sendButton?.layer.shadowOpacity = 0.3
        self.sendButton?.layer.shadowOffset = CGSizeMake(0, -3)
        self.sendButton?.addTarget(self, action: #selector(ViewController.sendButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.sendButton!)
        
        let footerView: APIAddParameterFooterView = APIAddParameterFooterView.init(frame: CGRectMake(0, 0, aScreenWidth, 50))
        self.tableView?.tableFooterView = footerView
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ViewController.tableFooterViewTapped(_:)))
        self.tableView?.tableFooterView?.addGestureRecognizer(tapGesture)
        
        //Reactive Cocoa
        
//        let validUrlSignal: RACSignal = (self.headerView?.urlTextField?.rac_textSignal().map({ (text) -> AnyObject! in
//            return NSNumber(bool: self.isValidUrl(text as! String))
//        }))!
        
        self.headerView?.urlTextField?.rac_textSignal().map({ (next) -> AnyObject! in
            if let text: String? = next as? String
            {
                return self.isValidUrl(text!) ? UIColor.greenColor() : UIColor.redColor()
            }
        }).subscribeNext({ (next) -> Void in
            if let color: UIColor? = next as? UIColor
            {
                self.headerView?.urlTextField?.layer.borderColor = color?.CGColor
            }
        })
        
//        RAC(self.headerView.urlTextField, "backgroundColor") = validUrlSignal.map({ (urlValid) -> AnyObject! in
//            return urlValid.boolValue ? UIColor.greenColor() : UIColor.redColor()
//        })
    }
    
    //MARK: RAC macro replacement
    
//    struct RAC  {
//        var target : NSObject!
//        var keyPath : String!
//        var nilValue : AnyObject!
//        
//        init(_ target: NSObject!, _ keyPath: String, nilValue: AnyObject? = nil) {
//            self.target = target
//            self.keyPath = keyPath
//            self.nilValue = nilValue
//        }
//        
//        
//        func assignSignal(signal : RACSignal) {
//            signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
//        }
//    }
    
//    struct RAC  {
//        var target : NSObject!
//        var keyPath : String!
//        var nilValue : AnyObject!
//        
//        init(_ target: NSObject!, _ keyPath: String, nilValue: AnyObject? = nil) {
//            self.target = target
//            self.keyPath = keyPath
//            self.nilValue = nilValue
//        }
//        
//        func assignSignal(signal : RACSignal) {
//            signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
//        }
//    }
    
//    operator infix ~> {}
//    @infix func ~> (signal: RACSignal, rac: RAC) {
//    rac.assignSignal(signal)
//    }
    
    //MARK: Custom
    
    func loadInitParams() -> Void
    {
        self.params = [APIParameter]()
        for _ in 0...3
        {
            self.params?.append(APIParameter(key: "", value: ""))
        }
    }
    
    func isValidUrl(url: String) -> Bool
    {
        return url.characters.count >= 4
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
        return (self.params?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            self.deleteCellWithModel(indexPath)
        }
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
        let headac = UIAlertAction(title: "HEAD", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.headerView?.methodLabel?.text = "HEAD"
        }
        let deleteac = UIAlertAction(title: "DELETE", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.headerView?.methodLabel?.text = "DELETE"
        }
        let cancelac = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            //do something
        }
        alertcontroller.addAction(getac)
        alertcontroller.addAction(postac)
        alertcontroller.addAction(headac)
        alertcontroller.addAction(deleteac)
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
        self.detectTextField(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        self.detectTextField(textField)
    }
    
    // MARK: APIHistoryViewControllerDelegate
    
    func historyViewController(tableView: UITableView, didSelectRecord record: NSDictionary, atIndexPath indexPath: NSIndexPath)
    {
        self.autoSetRecord(record)
        self.headerView?.urlTextField?.rac_textSignal().subscribeNext({ (next) -> Void in
            if let text: String? = next as? String
            {
                self.headerView?.urlTextField?.layer.borderColor = self.isValidUrl(text!) ? UIColor.greenColor().CGColor : UIColor.redColor().CGColor
            }
        })
    }
    
    // MARK: Helpers
    
    func tableFooterViewTapped(tap: UITapGestureRecognizer)
    {
        NSLog("tableFooterViewTapped")
        self.createNewCell()
    }
    
    func createNewCell() -> Void
    {
        self.params?.append(APIParameter(key: "", value: ""))
        self.tableView?.beginUpdates()
        let indexPath: NSIndexPath = NSIndexPath(forRow: self.params!.count - 1, inSection: 0)
        self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableView?.endUpdates()
    }
    
    func deleteCellWithModel(indexPath: NSIndexPath) -> Void
    {
        self.params?.removeAtIndex(indexPath.row)
        self.tableView?.beginUpdates()
        self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableView?.endUpdates()
    }
    
    func autoSetRecord(record: NSDictionary)
    {
        self.headerView?.urlTextField?.text = record[KEY_URL] as? String
        self.headerView?.methodLabel?.text = record[KEY_METHOD] as? String
    }
    
    func historyButtonPressed(sender: UIButton)
    {
        //调出历史记录页面
        NSLog("history")
        let historyvc = APIHistoryViewController()
        historyvc.delegate = self
        let navc = UINavigationController(rootViewController: historyvc)
        self.navigationController?.presentViewController(navc, animated: true, completion: { () -> Void in
            //do something
        })
    }
    
    func detectTextField(textField: UITextField)
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
    
    func sendButtonPressed(sender: UIButton)
    {
        if self.headerView?.urlTextField?.text?.characters.count < 1
        {
            return
        }
        self.sendingStateForSendButton(sender)
        
        let urlstr = self.assembleURL()
        let request = self.assembleNSURLRequest(urlstr as String)
        let urltext = self.validateURL((self.headerView?.urlTextField?.text)!)
        let methodtext = self.headerView?.methodLabel?.text
        let paramDict: NSMutableDictionary = NSMutableDictionary()
        for param: APIParameter in self.params! as [APIParameter]
        {
            paramDict.setObject(param.value!, forKey: param.key!)
        }
        let recordDict = self.assembleNSDictionary(urltext, params: paramDict, method: methodtext!)
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            APIUtils.saveRecordToPlist(recordDict)
        }
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, responseError) -> Void in
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
                self.recoverStateForSendButton(sender)
            })
        }.resume()
    }
    
    func sendingStateForSendButton(sender: UIButton)
    {
        sender.setTitle("SENDING", forState: UIControlState.Disabled)
        sender.enabled = false
    }
    
    func recoverStateForSendButton(sender: UIButton)
    {
        sender.setTitle("SEND", forState: UIControlState.Disabled)
        sender.enabled = true
    }
    
    func assembleURL() -> NSString
    {
        var params: [APIParameter] = [APIParameter]()
        for index in 0...((self.params?.count)! - 1)
        {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell = self.tableView?.cellForRowAtIndexPath(indexPath) as! APIParameterTableViewCell
            if cell.keyTextField?.text?.characters.count < 1 || cell.valueTextField?.text?.characters.count < 1
            {
                continue
            }
            else
            {
                let value: String = (cell.valueTextField?.text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " ")))!
                let key: String = (cell.keyTextField?.text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " ")))!
                let param: APIParameter = APIParameter(key: key, value: value)
                params.append(param)
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
        
        for param: APIParameter in params
        {
            if param.key!.isEqual(params.first) == true //第一个参数不加&
            {
                urlstr = urlstr!.stringByAppendingFormat("\((param.key)!)=\((param.value)!)")
            }
            else
            {
                urlstr = urlstr!.stringByAppendingFormat("&\((param.key)!)=\((param.value)!)")
            }
        }
        
        if urlstr?.hasSuffix("?") == true
        {
            urlstr = urlstr?.stringByReplacingOccurrencesOfString("?", withString: "")
        }
        
        let finalUrl = self.validateURL(urlstr as! String)
        
        NSLog("final url: \(finalUrl)")
        
        return finalUrl
    }
    
    func validateURL(url: String) -> String
    {
        return url.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " ")).stringByReplacingOccurrencesOfString(" ", withString: "")
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
    
    func assembleNSDictionary(url: String, params: NSDictionary?, method: String) -> NSDictionary
    {
        let record: NSMutableDictionary = NSMutableDictionary()
        record.setValue(url, forKey: KEY_URL)
        record.setValue(params, forKey: KEY_PARAMETERS)
        record.setValue(method, forKey: KEY_METHOD)
        return record
    }
    
//    func saveRecordToPlist(record: NSDictionary)
//    {
//        var mutableRecords: NSMutableArray?
//        if APIUtils.readRecordsFromPlist(APIUtils.plistPathForFilename(filename)) != nil
//        {
//            let records: NSArray = (APIUtils.readRecordsFromPlist(APIUtils.plistPathForFilename(filename)))!
//            mutableRecords = NSMutableArray(array: records)
//            mutableRecords!.addObject(record)
//        }
//        else
//        {
//            mutableRecords = NSMutableArray(object: record)
//        }
//        self.saveRecordsToPlist(mutableRecords! as NSArray)
//    }
//    
//    func saveRecordsToPlist(records: NSArray)
//    {
//        let recordsDict: NSDictionary = ["records": records]
//        let manager = NSFileManager.defaultManager()
//        let plistPath = APIUtils.plistPathForFilename(filename)
//        if manager.fileExistsAtPath(plistPath) == false
//        {
//            let isCreated = manager.createFileAtPath(plistPath, contents: nil, attributes: nil)
//            NSLog("创建结果: \(isCreated)")
//        }
//        else
//        {
//            let isWritten = recordsDict.writeToFile(plistPath, atomically: true)
//            NSLog("写入结果: \(isWritten)")
//        }
//    }
}

