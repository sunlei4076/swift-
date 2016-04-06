//
//  JsonDicHelper.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/9.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class JsonDicHelper: NSObject {
    static func getJsonDicValue(dic:Dictionary<String,AnyObject>, key:String)->String
    {
        var rtn:String = ""
        if let value: AnyObject = dic[key]{
            rtn = self.objectToString(value)
        }else{
            //无对应key
        }
        return rtn
    }
    
    static func objectToString(object:AnyObject)->String{
        let rtn:String
        
//        pprLog(object)
        
        switch object {
            
//        case is Float:
//            rtn = String(stringInterpolationSegment: object as! Float64)
            
//  test case
        case is Int:
            //由于float也会进入int case
//            pprLog(object)
            let objFloat:Float = object as! Float
            let objInt:Int = object as! Int
            
            if (objFloat - Float(objInt)) > 0.0{
                rtn = String(stringInterpolationSegment: object as! Float)
//                pprLog("is float")
            }else{
                rtn = String(object as! Int)
//                pprLog("is int")
            }

        case is String:
            rtn = object as! String
        case is Bool:
            rtn = String(stringInterpolationSegment: object as! Bool)
        default:
            rtn = ""
        }
        return rtn
    }
    
    static func getJsonDicDictionary(dic:Dictionary<String,AnyObject>, key:String)->Dictionary<String,AnyObject>{
        var rtn:Dictionary<String,AnyObject> = [:]
        if let resultDic:AnyObject = dic[key]{
            if resultDic is Dictionary<String,AnyObject>{
                rtn = resultDic as! Dictionary<String,AnyObject>
            }
        }else{
            //无对应key
        }
        return rtn
    }
    
    static func getJsonDicArray(dic:Dictionary<String,AnyObject>, key:String)->[AnyObject]{
        var rtn = [AnyObject]()
        if let resultArray: AnyObject = dic[key]{
            if resultArray is [AnyObject]{
                rtn = resultArray as! [AnyObject]
            }
        }else{
            //无对应key
        }
        return rtn
    }
}
