//
//  FeedModel.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/8/24.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class FeedModel: NSObject {
    //feed类型
    var feed_type:String = ""
    
    //时间
    var dateline:String = ""
    //头像
    var avatar:String = ""
    //名称
    var user_name:String = ""
    //距离
    var distance:String = ""
    //message
    var message:String = ""
    //链接URL
    var url:String = ""
    //链接URLS
    var urls = [AnyObject]()
    //feed类型
    var webViewType = ""
    
    
    /*********订单feed*********/
    //小区名称
    var xiaoqu_name:String = ""
    //店铺名称
    var store_name:String = ""
    //购买商品数量
    var goods_total:String = ""
    //订单商品
    var goods_list:[GoodModel] = []
    
    /*********公告feed*********/
    var notice_title:String = ""
    var notice_pic:String = ""
    
    /*********界面使用*********/
    var cellHeight:CGFloat = 0
    var isShowAll:Bool = false
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.feed_type = JsonDicHelper.getJsonDicValue(jsonDic, key: "feed_type")
        self.dateline = JsonDicHelper.getJsonDicValue(jsonDic, key: "dateline")
        self.avatar = JsonDicHelper.getJsonDicValue(jsonDic, key: "avatar")
        self.distance = JsonDicHelper.getJsonDicValue(jsonDic, key: "distance")
        self.user_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "user_name")
        webViewType = JsonDicHelper.getJsonDicValue(jsonDic, key: "web_view_type")
        
        if self.feed_type == "order"{
            self.xiaoqu_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "xiaoqu_name")
            self.url = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_url")
            self.urls = JsonDicHelper.getJsonDicArray(jsonDic, key: "urls")
            self.store_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_name")
            self.goods_total = JsonDicHelper.getJsonDicValue(jsonDic, key: "goods_total")
            
            let goodsArray = JsonDicHelper.getJsonDicArray(jsonDic, key: "goods_list")
            for item in goodsArray{
                if item is Dictionary<String,AnyObject>{
                    let good = GoodModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.goods_list.append(good)
                }
            }
            let total = (self.goods_total as NSString).integerValue
            self.message = "在#\(self.store_name)#购买了\(total)件商品"
//            self.message =
        }else if self.feed_type == "text_feed"{
            self.message = JsonDicHelper.getJsonDicValue(jsonDic, key: "message")
            self.url = JsonDicHelper.getJsonDicValue(jsonDic, key: "url")
            self.urls = JsonDicHelper.getJsonDicArray(jsonDic, key: "urls")
        
        }else if self.feed_type == "add_notice"{
            self.notice_title = JsonDicHelper.getJsonDicValue(jsonDic, key: "notice_title")
            self.notice_pic = JsonDicHelper.getJsonDicValue(jsonDic, key: "notice_pic")
            self.urls = JsonDicHelper.getJsonDicArray(jsonDic, key: "urls")
            self.url = JsonDicHelper.getJsonDicValue(jsonDic, key: "notice_url")
            self.message = JsonDicHelper.getJsonDicValue(jsonDic, key: "message")
        }else{
        
        }
    }
}
