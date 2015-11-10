//
//  APIURLTableViewCell.swift
//  APITool
//
//  Created by Zhouboli on 15/11/10.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit

class APIURLTableViewCell: UITableViewCell
{
    var urlTextField: UITextField?
    
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
        self.urlTextField = UITextField()
        self.urlTextField?.frame = CGRectMake(10, 10, UIScreen.mainScreen().bounds.size.width - 20, 30)
        self.urlTextField?.textColor = UIColor.blackColor()
        self.urlTextField?.backgroundColor = UIColor.whiteColor()
        self.urlTextField?.placeholder = "URL"
        self.contentView.addSubview(self.urlTextField!)
    }
}