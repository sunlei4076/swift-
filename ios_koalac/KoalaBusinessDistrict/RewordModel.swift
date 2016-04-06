//
//  RewordModel.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/11/11.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class RewordModel: NSObject {
    var pointsGet:String = ""
    var experienceGet:String = ""
    var preLevelName:String = ""
    var nextLevelName:String = ""
    var experienceTotal:String = ""
    var preLevelExperience:String = ""
    var nextLevelExperience:String = ""
    var creditRuleArray = [CreditRuleModel]()
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.pointsGet = JsonDicHelper.getJsonDicValue(jsonDic, key: "points_get")
        self.experienceGet = JsonDicHelper.getJsonDicValue(jsonDic, key: "experience_get")
        self.preLevelName = JsonDicHelper.getJsonDicValue(jsonDic, key: "pre_level_name")
        self.nextLevelName = JsonDicHelper.getJsonDicValue(jsonDic, key: "next_level_name")
        self.experienceTotal = JsonDicHelper.getJsonDicValue(jsonDic, key: "experience_total")
        self.preLevelExperience = JsonDicHelper.getJsonDicValue(jsonDic, key: "pre_level_experience")
        self.nextLevelExperience = JsonDicHelper.getJsonDicValue(jsonDic, key: "next_level_experience")
        
        let array:[AnyObject] = JsonDicHelper.getJsonDicArray(jsonDic, key: "credit_rule")
        for item in array {
            if item is Dictionary<String,AnyObject>{
                let xiaoqu = CreditRuleModel(jsonDic: item as! Dictionary<String, AnyObject>)
                self.creditRuleArray.append(xiaoqu)
            }
        }
    }
}

class CreditRuleModel:NSObject{
    var ruleName:String = ""
    var credit:String = ""
    var experience:String = ""
    var message:String = ""
    var downloadUrl:String = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.ruleName = JsonDicHelper.getJsonDicValue(jsonDic, key: "rulename")
        self.credit = JsonDicHelper.getJsonDicValue(jsonDic, key: "credit")
        self.experience = JsonDicHelper.getJsonDicValue(jsonDic, key: "experience")
        self.downloadUrl = JsonDicHelper.getJsonDicValue(jsonDic, key: "download_url")
        self.message = JsonDicHelper.getJsonDicValue(jsonDic, key: "message")
    }
}