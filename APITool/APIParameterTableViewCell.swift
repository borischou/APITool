//
//  APIParameterTableViewCell.swift
//  APITool
//
//  Created by Zhouboli on 15/11/10.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit

protocol APIParameterTableViewCellDelegate
{
    func parameterTableViewCell(cell: APIParameterTableViewCell, didPressDeleteButton deleteButton: UIButton)
}

class APIParameterTableViewCell: UITableViewCell
{
    var keyTextField: UITextField?
    var valueTextField: UITextField?
    var deleteButton: UIButton?
    var delegate: APIParameterTableViewCellDelegate?
    
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
        let itemWidth: CGFloat = (UIScreen.mainScreen().bounds.size.width - 30 - 50)/2
        let itemHeight: CGFloat = 50.0

        self.keyTextField = UITextField()
        self.keyTextField?.frame = CGRectMake(10, 0, itemWidth, itemHeight)
        self.keyTextField?.placeholder = "key"
        self.contentView.addSubview(self.keyTextField!)
        
        self.valueTextField = UITextField()
        self.valueTextField?.frame = CGRectMake(20 + itemWidth, 0, itemWidth, itemHeight)
        self.valueTextField?.placeholder = "value"
        self.contentView.addSubview(self.valueTextField!)
        
        self.deleteButton = UIButton()
        self.deleteButton?.frame = CGRectMake(30 + itemWidth * 2, 0, itemHeight, itemHeight)
        self.deleteButton?.setTitle("DEL", forState: UIControlState.Normal)
        self.deleteButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.deleteButton?.backgroundColor = UIColor.greenColor()
        self.deleteButton?.addTarget(self, action: "deleteButtonPressed", forControlEvents: UIControlEvents.TouchDragInside)
        self.contentView.addSubview(self.deleteButton!)
    }
    
    func deleteButtonPressed()
    {
        self.delegate?.parameterTableViewCell(self, didPressDeleteButton: self.deleteButton!)
    }
}