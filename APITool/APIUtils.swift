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
    class func plistPathForFilename(filename: String) -> String
    {
        //获取Library/Caches目录
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let cachesDirectory: NSString = paths.firstObject as! NSString
        
        //将文件名拼在目录后面形成完整文件路径
        return cachesDirectory.stringByAppendingPathComponent(filename)
    }
    
    class func readRecordsFromPlist(path: String) -> NSArray?
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
    
    class func deleteRecordAtIndex(index: Int) -> Bool
    {
        let records = self.readRecordsFromPlist(self.plistPathForFilename(filename))
        if records != nil
        {
            let mutableRecords = NSMutableArray(array: records!)
            mutableRecords.removeObjectAtIndex(index)
            self.saveRecordsToPlist(mutableRecords.copy() as! NSArray)
            return true
        }
        return false
    }
    
    class func removeAllRecords()
    {
        let records = self.readRecordsFromPlist(self.plistPathForFilename(filename))
        if records == nil
        {
            return
        }
        else
        {
            let mutableRecords = NSMutableArray(array: records!)
            mutableRecords.removeAllObjects()
            self.saveRecordsToPlist(mutableRecords.copy() as! NSArray)
        }
    }
    
    class func saveRecordToPlist(record: NSDictionary)
    {
        var mutableRecords: NSMutableArray
        if self.readRecordsFromPlist(self.plistPathForFilename(filename)) != nil
        {
            let records: NSArray = (self.readRecordsFromPlist(self.plistPathForFilename(filename)))!
            mutableRecords = records.mutableCopy() as! NSMutableArray
            mutableRecords.addObject(record)
        }
        else
        {
            mutableRecords = NSMutableArray(object: record)
        }
        self.saveRecordsToPlist(mutableRecords as NSArray)
    }
    
    class func saveRecordsToPlist(records: NSArray)
    {
        let recordsDict: NSDictionary = ["records": records]
        let manager = NSFileManager.defaultManager()
        let plistPath = APIUtils.plistPathForFilename(filename)
        if manager.fileExistsAtPath(plistPath) == false
        {
            let isCreated = manager.createFileAtPath(plistPath, contents: nil, attributes: nil)
            if isCreated
            {
                let isWritten = recordsDict.writeToFile(plistPath, atomically: true)
                NSLog("创建结果: \(isCreated) 写入结果: \(isWritten)")
            }
        }
        else
        {
            let isWritten = recordsDict.writeToFile(plistPath, atomically: true)
            NSLog("写入结果: \(isWritten)")
        }
    }
}