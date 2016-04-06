//
//  OrderModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/18.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class OrderModel: NSObject {
    //订单id
    var order_id:String = ""
    //订单编号
    var order_sn:String = ""
    //客户名称
    var user_name:String = ""
    //下单时间
    var add_time:String = ""
    //客户头像
    var avatar:String = ""
    /*
    0，取消订单；
    11，待付款；
    20，已付款等待商家发货；
    30，卖家已发货；
    40，交易成功；
    17，表示商家没发货前，用户申请了退货；
    18，表示商家已经发货，且用户收货后申请了退货；
    19表示退货成功
    */
    var status:String = ""
    //配送时间
    var plan_ship_time = ""
    //客户地址
    var user_address = ""
    //客户电话
    var user_mobile = ""
    //支付方式
    var payType:String = ""
    
    //优惠券支付
    var couponPay = ""
    //运费
    var postage = ""
    //订单总额
    var total_money = ""
    //当面付优惠
    var faceToPay = ""
    //积分抵扣
    var pointsPay = ""
    //实收金额
    var realAmount = ""
    
    var orderExtension = ""
    
    var isSelectGoods = ""
    var goods:[GoodModel] = []
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.isSelectGoods = JsonDicHelper.getJsonDicValue(jsonDic, key: "isSelectGoods")
        self.orderExtension = JsonDicHelper.getJsonDicValue(jsonDic, key: "extension")
        self.order_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "order_id")
        self.order_sn = JsonDicHelper.getJsonDicValue(jsonDic, key: "order_sn")
        self.payType = JsonDicHelper.getJsonDicValue(jsonDic, key: "payment_code")
        let subOrderArray = JsonDicHelper.getJsonDicArray(jsonDic, key: "subOrder")
        let firstItem: AnyObject? = subOrderArray.first
        if firstItem != nil && firstItem is Dictionary<String, AnyObject>{
            let dic = firstItem as! Dictionary<String, AnyObject>
            couponPay = JsonDicHelper.getJsonDicValue(dic, key: "coupon_value")
            postage = JsonDicHelper.getJsonDicValue(dic, key: "postage")
            
            total_money = JsonDicHelper.getJsonDicValue(dic, key: "order_amount")
            faceToPay = JsonDicHelper.getJsonDicValue(dic, key: "fullcut_sales")
            pointsPay = JsonDicHelper.getJsonDicValue(dic, key: "point_discount")
            realAmount = JsonDicHelper.getJsonDicValue(dic, key: "real_amount")
            
            let goodArray = JsonDicHelper.getJsonDicArray(dic, key: "goods")
            for item in goodArray{
                let model = GoodModel(jsonDic: item as! Dictionary<String, AnyObject>)
                self.goods.append(model)
            }
        }
        self.add_time = JsonDicHelper.getJsonDicValue(jsonDic, key: "add_time")
        self.status = JsonDicHelper.getJsonDicValue(jsonDic, key: "status")
        self.plan_ship_time = JsonDicHelper.getJsonDicValue(jsonDic, key: "plan_ship_time")
        
        let userDic = JsonDicHelper.getJsonDicDictionary(jsonDic, key: "user")
        self.user_name = JsonDicHelper.getJsonDicValue(userDic, key: "user_name")
        self.avatar = JsonDicHelper.getJsonDicValue(userDic, key: "avatar")
        self.user_address = JsonDicHelper.getJsonDicValue(userDic, key: "address")
        self.user_mobile = JsonDicHelper.getJsonDicValue(userDic, key: "mobile")
    }
}
