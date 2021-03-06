//
//  APIMethodURLTableHeaderView.swift
//  APITool
//
//  Created by Zhouboli on 15/11/11.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit

protocol APIMethodURLTableHeaderViewDelegate
{
    func APIMethodURL(tableHeaderView: APIMethodURLTableHeaderView, didTapMethod methodLabel: UILabel)
}

class APIMethodURLTableHeaderView: UIView
{
    var delegate: APIMethodURLTableHeaderViewDelegate?
    var methodLabel: UILabel?
    var urlTextField: UITextField?

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews()
    {
        self.backgroundColor = UIColor.lightTextColor()
        
        let itemWidth = UIScreen.mainScreen().bounds.size.width - 20
        let itemHeight: CGFloat = 50.0
        
        self.methodLabel = UILabel()
        self.methodLabel?.frame = CGRectMake(10, 20, itemWidth, itemHeight)
        self.methodLabel?.userInteractionEnabled = true
        self.methodLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(APIMethodURLTableHeaderView.methodLabelTapped(_:))))
        self.methodLabel?.backgroundColor = UIColor.greenColor()
        self.methodLabel?.textColor = UIColor.whiteColor()
        self.methodLabel?.text = "GET"
        self.methodLabel?.textAlignment = NSTextAlignment.Center
        self.methodLabel?.layer.cornerRadius = 3.0
        self.methodLabel?.clipsToBounds = true
        self.addSubview(self.methodLabel!)
        
        self.urlTextField = UITextField()
        self.urlTextField?.frame = CGRectMake(10, 30 + itemHeight, itemWidth, itemHeight)
        self.urlTextField?.backgroundColor = UIColor.whiteColor()
        self.urlTextField?.font = UIFont.systemFontOfSize(13.0)
        self.urlTextField?.clearButtonMode = UITextFieldViewMode.Always
        self.urlTextField?.autocapitalizationType = UITextAutocapitalizationType.None
        self.urlTextField?.placeholder = "Input API URL here"
        self.urlTextField?.keyboardType = UIKeyboardType.ASCIICapable
        self.urlTextField?.layer.cornerRadius = 3.0
        self.addSubview(self.urlTextField!)
    }
    
    func methodLabelTapped(tap: UITapGestureRecognizer) -> Void
    {
        NSLog("methodLabelTapped")
        self.delegate?.APIMethodURL(self, didTapMethod: self.methodLabel!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.urlTextField?.resignFirstResponder()
    }
}
