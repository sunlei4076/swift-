//
//  AccountDrawalModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class AccountDrawalModel: NSObject {
    var balance:String = ""
    var drawaled:String = ""
    var freeze:String = ""   //2.8版本新增字段
    var drawal_min:String = "500"
    var drawal_max:String = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.balance = JsonDicHelper.getJsonDicValue(jsonDic, key: "balance")
        self.drawaled = JsonDicHelper.getJsonDicValue(jsonDic, key: "drawaled")
        self.freeze = JsonDicHelper.getJsonDicValue(jsonDic, key: "freeze")
        self.drawal_min = JsonDicHelper.getJsonDicValue(jsonDic, key: "drawal_min")
        self.drawal_max = JsonDicHelper.getJsonDicValue(jsonDic, key: "drawal_max")

    }
}

//银行卡信息 V2.8已经不用
class BankCardInfoModel:NSObject{
    var accountid:String = ""
    var store_id:String = ""
    var cardtype:String = ""
    var cardname:String = ""
    var cardnumber:String = ""
    var posttime:String = ""
    var branch:String = ""
    var address:String = ""

    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.accountid = JsonDicHelper.getJsonDicValue(jsonDic, key: "accountid")
        self.store_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_id")
        self.cardtype = JsonDicHelper.getJsonDicValue(jsonDic, key: "cardtype")
        self.cardname = JsonDicHelper.getJsonDicValue(jsonDic, key: "cardname")
        self.cardnumber = JsonDicHelper.getJsonDicValue(jsonDic, key: "cardnumber")
        self.posttime = JsonDicHelper.getJsonDicValue(jsonDic, key: "posttime")
        self.branch = JsonDicHelper.getJsonDicValue(jsonDic, key: "branch")
        self.address = JsonDicHelper.getJsonDicValue(jsonDic, key: "address")
    }
}

//银行卡信息V2.8新模型
class BankCardInfoNewModel:NSObject{
    var store_bank_id:String = ""
    var bank_type_id:String = ""
    var bank_type_name:String = ""
    var bank_owner:String = ""
    var bank_account:String = ""
    var bank_branch:String = ""
    var bank_address:String = ""

    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.store_bank_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_bank_id")
        self.bank_type_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "bank_type_id")
        self.bank_type_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "bank_type_name")
        self.bank_owner = JsonDicHelper.getJsonDicValue(jsonDic, key: "bank_owner")
        self.bank_account = JsonDicHelper.getJsonDicValue(jsonDic, key: "bank_account")
        self.bank_branch = JsonDicHelper.getJsonDicValue(jsonDic, key: "bank_branch")
        self.bank_address = JsonDicHelper.getJsonDicValue(jsonDic, key: "bank_address")
    }
}


//已提现记录
class DrawalRecordModel:NSObject{
    
    var id:String = ""
    var cardtype:String = ""
    var cardnumber:String = ""
    var money:String = ""
    var checker:String = ""
    var checktime:String = ""
    var posttime:String = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.id = JsonDicHelper.getJsonDicValue(jsonDic, key: "id")
        self.cardtype = JsonDicHelper.getJsonDicValue(jsonDic, key: "cardtype")
        self.cardnumber = JsonDicHelper.getJsonDicValue(jsonDic, key: "cardnumber")
        self.money = JsonDicHelper.getJsonDicValue(jsonDic, key: "money")
        self.checker = JsonDicHelper.getJsonDicValue(jsonDic, key: "checker")
        self.checktime = JsonDicHelper.getJsonDicValue(jsonDic, key: "checktime")
        self.posttime = JsonDicHelper.getJsonDicValue(jsonDic, key: "posttime")
    }
}
//已提现记录 V2.8
class DrawalRecordNewModel:NSObject{

    var id:String = ""   //提现记录id
    var bank_type_name:String = ""//银行类型名
    var bank_account:String = ""//提现申请银行卡号
    var money:String = ""//提现申请金额
    var apply_time:String = ""//提现申请时间
    var apply_status:String = ""//提现申请状态

    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.id = JsonDicHelper.getJsonDicValue(jsonDic, key: "id")
        self.bank_type_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "bank_type_name")
        self.bank_account = JsonDicHelper.getJsonDicValue(jsonDic, key: "bank_account")
        self.money = JsonDicHelper.getJsonDicValue(jsonDic, key: "money")
        self.apply_time = JsonDicHelper.getJsonDicValue(jsonDic, key: "apply_time")
        self.apply_status = JsonDicHelper.getJsonDicValue(jsonDic, key: "apply_status")

    }
}
