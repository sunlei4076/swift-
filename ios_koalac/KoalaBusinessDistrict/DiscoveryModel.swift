//
//  DiscoveryModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/8/21.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class DiscoveryModel: NSObject {
    var discovery_Id:String = ""
    var discovery_Title:String = ""
    var discovery_IconUrl:String = ""
    var discovery_Group:String = ""
    var discovery_Update:String = ""
    var discovery_ClickUrl:String = ""
    var discovery_tag = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.discovery_Id = JsonDicHelper.getJsonDicValue(jsonDic, key: "id")
        self.discovery_Title = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_name")
        self.discovery_IconUrl = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_icon_m")
        self.discovery_Group = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_group")
        self.discovery_ClickUrl = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_url")
        self.discovery_tag = JsonDicHelper.getJsonDicValue(jsonDic, key: "tab_tag")
        self.discovery_Update = "0"
    }
}
