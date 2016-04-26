//
//  APIAddParameterFooterView.swift
//  APITool
//
//  Created by Zhouboli on 16/4/26.
//  Copyright © 2016年 Boris. All rights reserved.
//

import Foundation
import UIKit

class APIAddParameterFooterView: UIView
{
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initSubviews()
    }
    
    func initSubviews() -> Void
    {
        let smallGap: CGFloat = 5
        let viewHeight: CGFloat = self.frame.size.height
        let viewWidth: CGFloat = self.frame.size.width
        let layerHeight: CGFloat = viewHeight - 2 * smallGap
        let layerWidth: CGFloat = viewWidth - 2 * smallGap
        let bigGap: CGFloat = 15
        let iconLength: CGFloat = viewHeight - 2 * bigGap
        
        let borderLayer: CAShapeLayer = CAShapeLayer.init()
        borderLayer.strokeColor = UIColor.lightGrayColor().CGColor
        borderLayer.fillColor = UIColor.whiteColor().CGColor
        borderLayer.path = UIBezierPath.init(rect: CGRectMake(smallGap, smallGap, layerWidth, layerHeight)).CGPath
        borderLayer.lineWidth = 1.0
        borderLayer.lineCap = "square"
        borderLayer.frame = self.bounds
        borderLayer.lineDashPattern = [4, 2]
        self.layer.addSublayer(borderLayer)
        
        let iconLayer = CALayer.init()
        iconLayer.frame = CGRectMake(viewWidth/2-iconLength/2, bigGap, iconLength, iconLength)
        iconLayer.contents = UIImage(named: "icon_add_row")?.CGImage
        self.layer.addSublayer(iconLayer)
    }
}