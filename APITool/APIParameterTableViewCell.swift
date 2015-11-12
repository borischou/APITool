//
//  APIParameterTableViewCell.swift
//  APITool
//
//  Created by Zhouboli on 15/11/10.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit

class APIParameterTableViewCell: UITableViewCell
{
    var keyTextField: UITextField?
    var valueTextField: UITextField?
    var deleteButton: UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.initSubviews()
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews()
    {
        let itemWidth: CGFloat = (UIScreen.mainScreen().bounds.size.width - 80)/2
        let itemHeight: CGFloat = 40.0

        self.keyTextField = UITextField()
        self.keyTextField?.frame = CGRectMake(10, 5, itemWidth, itemHeight)
        self.keyTextField?.placeholder = "key"
        self.keyTextField?.font = UIFont.systemFontOfSize(13.0)
        self.keyTextField?.clearButtonMode = UITextFieldViewMode.Always
        self.keyTextField?.autocapitalizationType = UITextAutocapitalizationType.None
        self.contentView.addSubview(self.keyTextField!)
        
        self.valueTextField = UITextField()
        self.valueTextField?.frame = CGRectMake(20 + itemWidth, 5, itemWidth, itemHeight)
        self.valueTextField?.placeholder = "value"
        self.valueTextField?.font = UIFont.systemFontOfSize(13.0)
        self.valueTextField?.clearButtonMode = UITextFieldViewMode.Always
        self.valueTextField?.autocapitalizationType = UITextAutocapitalizationType.None
        self.contentView.addSubview(self.valueTextField!)
        
        self.deleteButton = UIButton()
        self.deleteButton?.frame = CGRectMake(30 + itemWidth * 2, 5, itemHeight, itemHeight)
        self.deleteButton?.setTitle("DEL", forState: UIControlState.Normal)
        self.deleteButton?.titleLabel?.font = UIFont.systemFontOfSize(13.0)
        self.deleteButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.deleteButton?.backgroundColor = UIColor.greenColor()
        self.deleteButton?.addTarget(self, action: "deleteButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(self.deleteButton!)
    }
    
    func deleteButtonPressed(sender: UIButton)
    {
        self.keyTextField?.text = ""
        self.valueTextField?.text = ""
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.keyTextField?.resignFirstResponder()
        self.valueTextField?.resignFirstResponder()
    }
}