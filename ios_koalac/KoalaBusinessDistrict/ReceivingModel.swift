//
//  ReceivingModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/17.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ReceivingModel: NSObject {
    var storeId:String = ""
    var name:String = ""
    var status:String = ""
    var avatar:String = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        let sellerDic = JsonDicHelper.getJsonDicDictionary(jsonDic, key: "seller")
        self.storeId = JsonDicHelper.getJsonDicValue(sellerDic, key: "store_id")
        self.name = JsonDicHelper.getJsonDicValue(sellerDic, key: "name")
        self.avatar = JsonDicHelper.getJsonDicValue(sellerDic, key: "avatar")
        self.status = JsonDicHelper.getJsonDicValue(jsonDic, key: "status")
    }
}

class ReceivingDetailModel:NSObject{
    var goods_name:String = ""
    var goods_image:String = ""
    var quantity:String = ""
    var status:String = ""
    var real_num:String = ""
    var stock_id:String = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        let goodsDic = JsonDicHelper.getJsonDicDictionary(jsonDic, key: "goods")
        self.goods_name = JsonDicHelper.getJsonDicValue(goodsDic, key: "goods_name")
        self.goods_image = JsonDicHelper.getJsonDicValue(goodsDic, key: "goods_image")
        self.quantity = JsonDicHelper.getJsonDicValue(goodsDic, key: "quantity")
        self.status = JsonDicHelper.getJsonDicValue(goodsDic, key: "status")
        self.real_num = JsonDicHelper.getJsonDicValue(goodsDic, key: "real_num")
        self.stock_id = JsonDicHelper.getJsonDicValue(goodsDic, key: "stock_id")
    }
}