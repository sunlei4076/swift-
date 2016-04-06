//
//  NewsModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/23.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class NewsModel: NSObject {
//                    var  latest_avator:String = ""
//                    var  latest_nickname:String = ""
//                    var  latest_timestamp:String = ""
//                    var  latest_text:String = ""
     var hx_ext:XHMessageExtModel?//消息体扩展字段
    var latest_dist_tel:String = ""//环信用户电话               
    var hxid:String = ""//环信ID

    var uid:String = ""//用户ID
    var userHeadIcon:String = "" //用户头像
    var userName:String = "" //用户名
    var unreadNum:String = "" //未读消息条数:0不显示
    var lastNew:String = ""//最后一条消息内容
    var newDate:String = ""//时间

    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.uid = JsonDicHelper.getJsonDicValue(jsonDic, key: "uid")
        self.userHeadIcon = JsonDicHelper.getJsonDicValue(jsonDic, key: "avatar")
        self.userName = JsonDicHelper.getJsonDicValue(jsonDic, key: "user_name")
        self.unreadNum = JsonDicHelper.getJsonDicValue(jsonDic, key: "unread_num")
        self.lastNew = JsonDicHelper.getJsonDicValue(jsonDic, key: "newest_message")
        self.newDate = JsonDicHelper.getJsonDicValue(jsonDic, key: "dateline")
    }
}
//EMMessage类型ext扩展字段模型
class XHMessageExtModel: NSObject {

    //1.商圈小助手最新商机
    var hx_id:String = ""
    var hx_imageurl:String = ""
    var hx_description:String = ""

    //==>2.环信字段
    var hx_target:String = ""//点击类型：self-原生APP打开，url-直接跳转到链接地址
    var hx_url:String = ""//点击跳转链接，当target为url类型时，直接通过这个链接跳转
    var hx_msg_type:String = "" //消息类型，取值有文字消息'txt',订单支付通知'orderpayed',发送订单'order',发送商品'goods',
    var hx_order_id:String = ""//订单id, 消息类型为orderpayed时有
    var hx_order_sn:String = ""//订单号,消息类型为orderpayed时有
    var hx_order_amount:String = ""//订单金额,消息类型为orderpayed时有
    var hx_xiaoqu_id:String = ""//小区id,消息类型为orderpayed时有
    var hx_goods_name:String = ""//商品名称,消息类型为orderpayed时有
    var hx_goods_image:String = ""//商品图片,消息类型为orderpayed时有
    var hx_quantity:String = "" //购买数量,消息类型为orderpayed时有
    var hx_nickname:String = ""//用户昵称
    var hx_avator:String = ""//用户头像
    var hx_disp_tel:String = ""//订单收货电话,消息类型为orderpayed时有
    var hx_goods_id:String = ""//商品id,消息类型为goods时有
    //    var hx_goods_image:String = "" //商品图片,消息类型为goods时有
    var hx_goods_price:String = ""//商品价格,消息类型为goods时有
    //    var hx_goods_name:String = ""//商品名,消息类型为goods时有
    var hx_goods_postage:String = ""//商品邮费,消息类型为goods时有
    var hx_goods_desc:String = ""//商品介绍,消息类型为goods时有
    //    var hx_order_id:String = ""//订单id,消息类型为order时有
    //    var hx_order_sn:String = ""// 订单号,消息类型为order时有
    var hx_order_image:String = ""//订单图片,消息类型为order时有
    convenience init(ext:Dictionary<String,AnyObject>){
        self.init()
        self.hx_target = JsonDicHelper.getJsonDicValue(ext, key: "target")
        self.hx_url = JsonDicHelper.getJsonDicValue(ext, key: "url")

        self.hx_msg_type = JsonDicHelper.getJsonDicValue(ext, key: "msg_type")
        self.hx_order_id = JsonDicHelper.getJsonDicValue(ext, key: "order_id")
        self.hx_order_sn = JsonDicHelper.getJsonDicValue(ext, key: "order_sn")
        self.hx_order_amount = JsonDicHelper.getJsonDicValue(ext, key: "order_amount")
        self.hx_xiaoqu_id = JsonDicHelper.getJsonDicValue(ext, key: "xiaoqu_id")
        self.hx_goods_name = JsonDicHelper.getJsonDicValue(ext, key: "goods_name")
        self.hx_goods_image = JsonDicHelper.getJsonDicValue(ext, key: "goods_image")
        self.hx_quantity = JsonDicHelper.getJsonDicValue(ext, key: "quantity")
        self.hx_nickname = JsonDicHelper.getJsonDicValue(ext, key: "nickname")
        self.hx_avator = JsonDicHelper.getJsonDicValue(ext, key: "avator")
        self.hx_disp_tel = JsonDicHelper.getJsonDicValue(ext, key: "disp_tel")
        self.hx_goods_id = JsonDicHelper.getJsonDicValue(ext, key: "goods_id")
        self.hx_goods_image = JsonDicHelper.getJsonDicValue(ext, key: "goods_image")
        self.hx_goods_image = JsonDicHelper.getJsonDicValue(ext, key: "goods_image")
        self.hx_goods_price = JsonDicHelper.getJsonDicValue(ext, key: "goods_price")
        self.hx_goods_name = JsonDicHelper.getJsonDicValue(ext, key: "goods_name")
        self.hx_goods_postage = JsonDicHelper.getJsonDicValue(ext, key: "goods_postage")
        self.hx_goods_desc = JsonDicHelper.getJsonDicValue(ext, key: "goods_desc")
        self.hx_order_id = JsonDicHelper.getJsonDicValue(ext, key: "order_id")
        self.hx_order_sn = JsonDicHelper.getJsonDicValue(ext, key: "order_sn")
        self.hx_order_image = JsonDicHelper.getJsonDicValue(ext, key: "order_image")
        //===
        self.hx_imageurl = JsonDicHelper.getJsonDicValue(ext, key: "imageurl")
        self.hx_description = JsonDicHelper.getJsonDicValue(ext, key: "description")
        self.hx_id = JsonDicHelper.getJsonDicValue(ext, key: "id")
    }
}

//text类型模型
class HXEMMessageForTextModel: NSObject {

    var hx_ext:XHMessageExtModel?//消息体扩展字段
    var hx_timeStamp:Int64 = 0 //Int时间戳
    var hx_timeStampForString:String = ""//时间
    var hx_messageText:String = ""//消息text内容
    var hx_cellHeight:CGFloat = 0//cell高度var 
    var hx_message_type:String = ""//消息类型

    var latest_dist_tel:String = ""//环信用户电话
    var hxid:String = ""//环信ID
    var uid:String = ""//用户ID
    var userHeadIcon:String = "" //用户头像
    var userName:String = "" //用户名
    var unreadNum:String = "" //未读消息条数:0不显示
    var lastNew:String = ""//最后一条消息内容
    var newDate:String = ""//时间
}

//过度text模型
class NewsDetailModel:NSObject{
    
    //********
    var model:MessageModel = MessageModel()
    var isNew:Bool = false
//    {
//        get{
//            if hx_ext?.hx_msg_type != "txt" && hx_ext?.hx_msg_type != nil{
//            return true
//            }else{
//            return false
//            }
//        }
//    }
    //********
    
    var hx_ext:XHMessageExtModel?//消息体扩展字段
    var hx_timeStamp:Int64 = 0
    //hx ext属性字段里面的消息类型
    var msg_type:String = ""
   
    //type标识谁发
    var hx_MessageOri = ""
    //保存cell高度
    var cellHeight:CGFloat = 0
    //用户ID
    var uid:String = ""
    //用户头像
    var userHeadIcon:String = ""
    //用户名称
    var userName:String = ""
    //订单ID
    var order_id:String = ""
    //消息类型
    var message_type:String = ""
    //消息时间
    var messageTime:String = ""   //hx
    //商品详情URL
    var goodsUrl:String = ""
    //商品图片
    var goodsImage:String = ""
    // 消息
    var message:String = ""
    //商品名称
    var goodsName:String = ""
    //消息内容
    var messageContent:String = "" //hx
    // 通知图片
    var noticePic:String = ""
    // 通知标题
    var noticeTitle:String = ""
    //通知链接
    var noticeUrl:String = ""
    //进货标题
    var wsShippedTitle = ""
    //进货商品url
    var wsShippedURL = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.message = JsonDicHelper.getJsonDicValue(jsonDic, key: "message")
        self.uid = JsonDicHelper.getJsonDicValue(jsonDic, key: "uid")
        self.userHeadIcon = JsonDicHelper.getJsonDicValue(jsonDic, key: "avatar")
        self.userName = JsonDicHelper.getJsonDicValue(jsonDic, key: "user_name")
        self.message_type = JsonDicHelper.getJsonDicValue(jsonDic, key: "message_type")
        self.messageTime = JsonDicHelper.getJsonDicValue(jsonDic, key: "dateline")
        self.messageContent = JsonDicHelper.getJsonDicValue(jsonDic, key: "comment_message")
        
        if(self.message_type == "verify"){
            self.noticePic = JsonDicHelper.getJsonDicValue(jsonDic, key: "notice_pic")
            self.noticeTitle = JsonDicHelper.getJsonDicValue(jsonDic, key: "notice_title")
            self.noticeUrl = JsonDicHelper.getJsonDicValue(jsonDic, key: "notice_url")
            self.messageContent = JsonDicHelper.getJsonDicValue(jsonDic, key: "message")
        }else if self.message_type == "text_message"{
            self.messageContent = JsonDicHelper.getJsonDicValue(jsonDic, key: "message")
        }else if self.message_type == "finishorder" {
            self.messageContent = JsonDicHelper.getJsonDicValue(jsonDic, key: "message")
        }else if self.message_type == "ws_shipped" {
            self.messageContent = JsonDicHelper.getJsonDicValue(jsonDic, key: "message")
            self.wsShippedTitle = JsonDicHelper.getJsonDicValue(jsonDic, key: "title")
            self.wsShippedURL = JsonDicHelper.getJsonDicValue(jsonDic, key: "ws_shipped_url")
        }
        
        let goodsArray = JsonDicHelper.getJsonDicArray(jsonDic, key: "goods_list")
        let firstOne: AnyObject? = goodsArray.first
        if firstOne != nil && firstOne is Dictionary<String,AnyObject>{
            let dic = firstOne as! Dictionary<String,AnyObject>
            self.goodsName = JsonDicHelper.getJsonDicValue(dic, key: "goods_name")
            self.goodsImage = JsonDicHelper.getJsonDicValue(dic, key: "goods_image")
            self.goodsUrl = JsonDicHelper.getJsonDicValue(dic, key: "goods_url")
            self.order_id = JsonDicHelper.getJsonDicValue(dic, key: "order_id")
        }
    }
}
