//
//  advertisingModel.swift
//  KoalaBusinessDistrict
//
//  Created by life on 15/11/20.
//  Copyright © 2015年 koalac. All rights reserved.
//

import  UIKit

class advertisingModel: NSObject {
    var ad_id:String = ""
    var image_big:String = ""
    var image_medium:String = ""
    var image_small:String = ""
    var ad_url:String = ""
    var start_time:String = ""
    var end_time:String = ""
    var is_need_click:String = ""
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.ad_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "ad_id")
        self.image_big = JsonDicHelper.getJsonDicValue(jsonDic, key: "image_big")
        self.image_medium = JsonDicHelper.getJsonDicValue(jsonDic, key: "image_medium")
        self.image_small = JsonDicHelper.getJsonDicValue(jsonDic, key: "image_small")
        self.ad_url = JsonDicHelper.getJsonDicValue(jsonDic, key: "ad_url")
        self.start_time = JsonDicHelper.getJsonDicValue(jsonDic, key: "start_time")
        self.end_time = JsonDicHelper.getJsonDicValue(jsonDic, key: "end_time")
        self.is_need_click = JsonDicHelper.getJsonDicValue(jsonDic, key: "is_need_click")
    }
}
