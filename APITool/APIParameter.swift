//
//  APIParameter.swift
//  APITool
//
//  Created by Zhouboli on 16/4/27.
//  Copyright © 2016年 Boris. All rights reserved.
//

import Foundation

class APIParameter: NSObject
{
    var key: String?
    var value: String?
    
    init(key: String, value: String)
    {
        super.init()
        self.key = key
        self.value = value
    }
}