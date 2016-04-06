//
//  HXMessageModel.swift
//  KoalaBusinessDistrict
//
//  Created by seekey on 15/12/11.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class HXMessageModel: NSObject {
    var hxUsername:String = ""
    var hxPassword:String = ""
    
    static let sharedHXInstance:HXMessageModel = HXMessageModel()
    class func getSharedHXInstance() ->HXMessageModel {
        
        return sharedHXInstance
    }
    
    func setHXDataWithJson(objDic:Dictionary<String,AnyObject>) {
        self.hxUsername = JsonDicHelper.getJsonDicValue(objDic, key: "hx_username")
        self.hxPassword = JsonDicHelper.getJsonDicValue(objDic, key: "hx_password")
    }
    
}
