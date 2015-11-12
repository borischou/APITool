//
//  APIUtils.swift
//  APITool
//
//  Created by Zhouboli on 15/11/12.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation

class APIUtils: NSObject
{
    static func plistPathForFilename(filename: String) -> String
    {
        //获取Library/Caches目录
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let cachesDirectory: NSString = paths.firstObject as! NSString
        
        //将文件名拼在目录后面形成完整文件路径
        return cachesDirectory.stringByAppendingPathComponent(filename)
    }
    
    static func readRecordsFromPlist(path: String) -> NSArray?
    {
        let recordsDict: NSDictionary? = NSDictionary(contentsOfFile: path)
        if recordsDict != nil && recordsDict!["records"] != nil
        {
            return recordsDict!["records"] as? NSArray
        }
        else
        {
            return nil
        }
    }
}