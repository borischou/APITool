//
//  APIResultViewController.swift
//  APITool
//
//  Created by Zhouboli on 15/11/11.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit

class APIResultViewController: UIViewController
{
    var resultTextView: UITextView?
    var result: NSString?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let textRect = CGRectMake(10, 20, self.view.frame.size.width - 20, self.view.frame.size.height - 40)
        self.resultTextView = UITextView(frame: textRect)
        self.resultTextView?.backgroundColor = UIColor.whiteColor()
        self.resultTextView?.font = UIFont.systemFontOfSize(13.0)
        self.resultTextView?.textColor = UIColor.blackColor()
        self.resultTextView?.editable = false
        self.view.addSubview(self.resultTextView!)
        self.resultTextView?.text = self.result as! String
    }
}