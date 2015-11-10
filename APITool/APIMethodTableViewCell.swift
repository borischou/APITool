//
//  APIMethodTableViewCell.swift
//  APITool
//
//  Created by Zhouboli on 15/11/10.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit

class APIMethodTableViewCell: UITableViewCell
{
    var methodLabel: UILabel?
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
        self.methodLabel = UILabel()
        self.methodLabel?.frame = CGRectMake(10, 10, UIScreen.mainScreen().bounds.size.width/2, 30)
        self.methodLabel?.textColor = UIColor.lightTextColor()
        self.methodLabel?.backgroundColor = UIColor.greenColor()
        self.contentView.addSubview(self.methodLabel!)
    }
}