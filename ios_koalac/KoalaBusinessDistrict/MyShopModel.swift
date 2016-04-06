//
//  MyShopModel.swift
//  KoalaBusinessDistrict
//
//  Created by seekey on 15/11/12.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

//分组
class MyShopModel: NSObject {
    var myShop_Group:String = ""
    var myShop_GroupName = ""
    //商品封面图片
    var tabModels:[tabModel] = []
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.myShop_Group = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_group")
        self.myShop_GroupName = JsonDicHelper.getJsonDicValue(jsonDic, key: "group_name")
        let imagesArray = JsonDicHelper.getJsonDicArray(jsonDic, key: "tab_list")
        for item in imagesArray{
            if item is Dictionary<String, AnyObject>{
                let taberModel = tabModel(jsonDic: (item as! Dictionary<String,AnyObject>))
                self.tabModels.append(taberModel)
            }
        }
    }
}

//组内元素
class tabModel:NSObject{
    
    var myShop_Id:String = ""
    var myShop_tabName:String = ""
    var myShop_IconUrl:String = ""
    var myShop_ClickUrl:String = ""
    var myShop_Type:String = ""
    var myShop_Tag:String = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.myShop_Id = JsonDicHelper.getJsonDicValue(jsonDic, key: "id")
        self.myShop_tabName = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_name")
        //6p取大图
        if screenWidth >= 414.0 {
            self.myShop_IconUrl = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_icon_b")
        }else {
            self.myShop_IconUrl = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_icon_m")
        }
        self.myShop_ClickUrl = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_url")
        self.myShop_Type = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_type")
        self.myShop_Tag = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_tag")
    }
}
