//
//  APIHistoryViewController.swift
//  APITool
//
//  Created by Zhouboli on 15/11/12.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit

class APIHistoryViewController: UIViewController
{
    var tableView: UITableView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "History"
        
        //历史记录表格
        let tvRect = UIScreen.mainScreen().bounds
        self.tableView = UITableView(frame: tvRect, style: UITableViewStyle.Plain)
        self.tableView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tableView!)
        
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
}