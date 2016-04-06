//
//  CustomerModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/14.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

//客户Model
class CustomerModel: NSObject {
    
    var group_name:String = ""
    var cust_id:String = ""
    var uid:String = ""
    var store_id:String = ""
    var name:String = ""
    var store_name:String = ""
    var attention:String = ""
    var avatar:String = ""
    var address:String = ""
    var tel:String = ""
    var dateline:String = ""
    var order_total:String = ""
    var money_total:String = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.group_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "group_name")
        self.cust_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "cust_id")
        self.uid = JsonDicHelper.getJsonDicValue(jsonDic, key: "uid")
        self.store_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_id")
        self.name = JsonDicHelper.getJsonDicValue(jsonDic, key: "name")
        self.store_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_name")
        self.attention = JsonDicHelper.getJsonDicValue(jsonDic, key: "attention")
        self.group_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "group_name")
        self.avatar = JsonDicHelper.getJsonDicValue(jsonDic, key: "avatar")
        self.address = JsonDicHelper.getJsonDicValue(jsonDic, key: "address")
        self.tel = JsonDicHelper.getJsonDicValue(jsonDic, key: "tel")
        self.dateline = JsonDicHelper.getJsonDicValue(jsonDic, key: "dateline")
        self.order_total = JsonDicHelper.getJsonDicValue(jsonDic, key: "order_total")
        self.money_total = JsonDicHelper.getJsonDicValue(jsonDic, key: "money_total")
    }
}

//客户订单
class CustomerOrderModel:NSObject{
    var customerName:String = ""
    var order_time:String = ""
    var orderList:[GoodModel] = []
    convenience init(jsonDic:Dictionary<String,AnyObject>, name:String){
        self.init()
        self.customerName = name
        self.order_time = JsonDicHelper.getJsonDicValue(jsonDic, key: "order_time")
        
        let subOrderArray = JsonDicHelper.getJsonDicArray(jsonDic, key: "subOrder")
        if subOrderArray.count > 0{
            let firstOrderDic = subOrderArray.first as! Dictionary<String, AnyObject>
            let goodsArray = JsonDicHelper.getJsonDicArray(firstOrderDic, key: "goods")
            for item in goodsArray{
                if item is Dictionary<String, AnyObject>{
                    let good = GoodModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.orderList.append(good)
                }
            }
        }
    }
    
}

//客户订单商品Model
class GoodModel: NSObject {
    var goods_name:String = ""
    var quantity:String = ""
    var goods_image:String = ""
    var good_url:String = ""
    /* 未使用到
    var rec_id:String = ""
    var order_id:String = ""
    var goods_id:String = ""
    var supply:String = ""
    var spec_id:String = ""
    var specification:String = ""
    var price:String = ""
    var orige_price:String = ""
    var evaluation:String = ""
    var comment:String = ""
    var credit_value:String = ""
    var is_valid:String = ""
    var store_id:String = ""
    */
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.goods_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "goods_name")
        self.quantity = JsonDicHelper.getJsonDicValue(jsonDic, key: "quantity")
        self.goods_image = JsonDicHelper.getJsonDicValue(jsonDic, key: "goods_image")
        self.good_url = JsonDicHelper.getJsonDicValue(jsonDic, key: "goods_url")
        /*
        self.rec_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "rec_id")
        self.order_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "order_id")
        self.goods_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "goods_id")
        self.supply = JsonDicHelper.getJsonDicValue(jsonDic, key: "supply")
        self.spec_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "spec_id")
        self.specification = JsonDicHelper.getJsonDicValue(jsonDic, key: "specification")
        self.price = JsonDicHelper.getJsonDicValue(jsonDic, key: "price")
        self.orige_price = JsonDicHelper.getJsonDicValue(jsonDic, key: "orige_price")
        self.evaluation = JsonDicHelper.getJsonDicValue(jsonDic, key: "evaluation")
        self.comment = JsonDicHelper.getJsonDicValue(jsonDic, key: "comment")
        self.credit_value = JsonDicHelper.getJsonDicValue(jsonDic, key: "credit_value")
        self.is_valid = JsonDicHelper.getJsonDicValue(jsonDic, key: "is_valid")
        self.store_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_id")
        */
    }
}
