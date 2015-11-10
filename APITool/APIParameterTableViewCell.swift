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
    var addButton: UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews()
    {
        let itemWidth: CGFloat = (UIScreen.mainScreen().bounds.size.width - 30)/2

        self.keyTextField = UITextField()
        self.keyTextField?.frame = CGRectMake(10, 10, itemWidth, 30)
        self.keyTextField?.placeholder = "key"
        self.keyTextField?.layer.borderWidth = 1.0
        self.keyTextField?.layer.borderColor = UIColor.greenColor().CGColor
        self.contentView.addSubview(self.keyTextField!)
        
        self.valueTextField = UITextField()
        self.valueTextField?.frame = CGRectMake(10 + itemWidth + 10, 10, itemWidth, 30)
        self.valueTextField?.placeholder = "value"
        self.valueTextField?.layer.borderWidth = 1.0
        self.valueTextField?.layer.borderColor = UIColor.greenColor().CGColor
        self.contentView.addSubview(self.valueTextField!)
        
        self.addButton = UIButton()
        //self.addButton?.frame = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
    }
}