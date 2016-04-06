//
//  MyShopSaleModel.swift
//  KoalaBusinessDistrict
//
//  Created by seekey on 15/11/14.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class MyShopSaleModel: NSObject {
    var moneyTotal:String = ""
    var orderTotal:String = ""
    var experienceTotal:String = ""
    var pointsTotal:String = ""
    var levelName:String = ""
    var openFacepayTotal:String = ""
    var levelPic:String = ""
    var picNum:String = ""
    var pv:String = ""
    var honestyScore:String = ""
    var honestyScoreTotal:String = ""
    var taskName:String = ""
    var taskStatus:String = ""
    var taskStatusName:String = ""
    var taskURL:String = ""
    var headURL:String = ""
    var storeMedalPic = ""
    var unfinishOrderTotal = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.moneyTotal = JsonDicHelper.getJsonDicValue(jsonDic, key: "money_total")
        self.orderTotal = JsonDicHelper.getJsonDicValue(jsonDic, key: "order_total")
        self.experienceTotal = JsonDicHelper.getJsonDicValue(jsonDic, key: "experience_total")
        self.pointsTotal = JsonDicHelper.getJsonDicValue(jsonDic, key: "points_total")
        self.levelName = JsonDicHelper.getJsonDicValue(jsonDic, key: "level_name")
        self.openFacepayTotal = JsonDicHelper.getJsonDicValue(jsonDic, key: "open_facepay_total")
        self.levelPic = JsonDicHelper.getJsonDicValue(jsonDic, key: "level_pic")
        self.picNum = JsonDicHelper.getJsonDicValue(jsonDic, key: "pic_num")
        self.pv = JsonDicHelper.getJsonDicValue(jsonDic, key: "pv")
        self.honestyScore = JsonDicHelper.getJsonDicValue(jsonDic, key: "honesty_score")
        self.honestyScoreTotal = JsonDicHelper.getJsonDicValue(jsonDic, key: "honesty_score_total")
        self.taskName = JsonDicHelper.getJsonDicValue(jsonDic, key: "task_name")
        self.taskStatus = JsonDicHelper.getJsonDicValue(jsonDic, key: "task_status")
        self.taskStatusName = JsonDicHelper.getJsonDicValue(jsonDic, key: "task_status_name")
        self.taskURL = JsonDicHelper.getJsonDicValue(jsonDic, key: "task_url")
        self.headURL = JsonDicHelper.getJsonDicValue(jsonDic, key: "head_url")
        self.storeMedalPic = JsonDicHelper.getJsonDicValue(jsonDic, key: "storeMedalPic")
        self.unfinishOrderTotal = JsonDicHelper.getJsonDicValue(jsonDic, key: "unfinish_order_total")
    }
    
}
