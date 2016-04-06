//
//  LoginInfoModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/9.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class LoginInfoModel: NSObject {
    
    var uid:String = ""
    var device_id:String = ""
    var m_auth:String = ""
    var real_name:String = ""
    var user_name:String = ""
    var member_type:String = ""
    var avatar:String = ""
    var mobile:String = ""
    var address:String = ""
    var xiaoquList = [XiaoQuModel]()
    var store:StoreModel = StoreModel()
    var ver:String = ""
    var had_drawalpwd:String = ""
    var openid = ""     //微信授权返回的openid
    
    //0:待审核，1：审核通过，2：已关闭， 3：注册成功但未提交店铺资料，4：审核不通过 -1：未开店
    var shopStatus:String = ""

    static let sharedInstance:LoginInfoModel = LoginInfoModel()
    
    class func getSharedInstance() ->LoginInfoModel {
        
        return sharedInstance
    }
//    //dispatch_once单例
//    class var sharedInstance : LoginInfoModel {
//        struct Static {
//            static var onceToken : dispatch_once_t = 0
//            static var instance : LoginInfoModel? = nil
//        }
//        dispatch_once(&Static.onceToken) {
//            Static.instance = LoginInfoModel()
//        }
//        return Static.instance!
//    }
    
    func setDataWithJson(jsonDic:Dictionary<String,AnyObject>){
        self.uid = JsonDicHelper.getJsonDicValue(jsonDic, key: "uid")
        self.device_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "device_id")
        self.m_auth = JsonDicHelper.getJsonDicValue(jsonDic, key: "m_auth")
        self.real_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "real_name")
        self.user_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "user_name")
        self.member_type = JsonDicHelper.getJsonDicValue(jsonDic, key: "member_type")
        self.avatar = JsonDicHelper.getJsonDicValue(jsonDic, key: "avatar")
        self.mobile = JsonDicHelper.getJsonDicValue(jsonDic, key: "mobile")
        self.address = JsonDicHelper.getJsonDicValue(jsonDic, key: "address")
        self.openid = JsonDicHelper.getJsonDicValue(jsonDic, key: "openid")
        //小区数组
        let xiaoQuArray:[AnyObject] = JsonDicHelper.getJsonDicArray(jsonDic, key: "xiaoqu")
        for item in xiaoQuArray {
            if item is Dictionary<String,AnyObject>{
                let xiaoqu = XiaoQuModel(jsonDic: item as! Dictionary<String, AnyObject>)
                self.xiaoquList.append(xiaoqu)
            }
        }
        
        let storeDic = JsonDicHelper.getJsonDicDictionary(jsonDic, key: "store")
        self.store = StoreModel(jsonDic: storeDic)
        self.ver = JsonDicHelper.getJsonDicValue(jsonDic, key: "ver")
        self.had_drawalpwd = JsonDicHelper.getJsonDicValue(jsonDic, key: "had_drawalpwd")
        
        if self.store.status.isEmpty{
            self.shopStatus = "-1"
        }else{
            self.shopStatus = self.store.status
        }
    }
}

class XiaoQuModel:NSObject,NSCopying{
    var xiaoqu_id:String = ""
    var xiaoqu_name:String = ""
    var locationid:String = ""
    
    //界面需要使用
    var isSelected:Bool = false
    override init(){
        super.init()
    }
    
    init(jsonDic:Dictionary<String,AnyObject>){
        self.xiaoqu_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "xiaoqu_id")
        self.xiaoqu_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "xiaoqu_name")
        self.locationid = JsonDicHelper.getJsonDicValue(jsonDic, key: "locationid")
        self.isSelected = true
        super.init()
    }
    
    init(copyItem:XiaoQuModel){
        self.isSelected = copyItem.isSelected
        self.xiaoqu_id = copyItem.xiaoqu_id
        self.xiaoqu_name = copyItem.xiaoqu_name
        self.locationid = copyItem.locationid
        super.init()
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let obj = XiaoQuModel(copyItem: self)
        return obj
    }
}

class StoreModel:NSObject {
    var store_id:String = ""
    var store_url:String = ""
    var app_store_url:String = ""
    var qrcode_store_url:String = ""
    var cate_id:String = ""
    var cate_name:String = ""
    var store_type:String = ""
    var store_name:String = ""
    var owner_name:String = ""
    var tel:String = ""
    var address:String = ""
    var store_banner:String = ""
    var store_logo:String = ""
    var description_t:String = ""
    var recommendInfo:String = ""
    var inviteOpenStoreURL:String = ""
    var facePayURL:String = ""
    var purchase_url:String = ""
    
    //覆盖半径
    var radius:String = ""
    //商家等级名称
    var grade_name:String = ""
    //覆盖小区限制数，0为无限多个
    var xiaoqu_limit:String = ""
    //发布商品限制数，0为无限多个
    var goods_limit:String = ""
    //1表示已经重设小区，0表示没有重设小区，2表示只需重设小区，无需重设省市区
    var reset_xiaoqu:String = ""
    
    var province: String = ""
    var city: String = ""
    var area: String = ""
    
    //是否绑定账户密码 1，绑定 0，未绑定
    var binded_user:String = ""
    
    //证件照；
    var idIamges: [String] = []
    
    var cityModel:CityInfoModel = CityInfoModel()
    
    var status:String = ""
    override init() {
        super.init()
    }
    
    init(jsonDic:Dictionary<String,AnyObject>){
        self.store_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_id")
        self.store_url = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_url")
        self.app_store_url = JsonDicHelper.getJsonDicValue(jsonDic, key: "app_store_url")
        self.qrcode_store_url = JsonDicHelper.getJsonDicValue(jsonDic, key: "qrcode_store_url")
        self.cate_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_id")
        self.cate_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_name")
        self.store_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_name")
        self.store_type = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_type")
        self.owner_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "owner_name")
        self.tel = JsonDicHelper.getJsonDicValue(jsonDic, key: "tel")
        self.address = JsonDicHelper.getJsonDicValue(jsonDic, key: "address")
        self.store_banner = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_banner")
        self.store_logo = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_logo")
        self.description_t = JsonDicHelper.getJsonDicValue(jsonDic, key: "description")
        self.radius = JsonDicHelper.getJsonDicValue(jsonDic, key: "radius")
        self.grade_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "grade_name")
        self.xiaoqu_limit = JsonDicHelper.getJsonDicValue(jsonDic, key: "xiaoqu_limit")
        self.goods_limit = JsonDicHelper.getJsonDicValue(jsonDic, key: "goods_limit")
        self.reset_xiaoqu = JsonDicHelper.getJsonDicValue(jsonDic, key: "reset_xiaoqu")
        
        self.province = JsonDicHelper.getJsonDicValue(jsonDic, key: "province")
        self.city = JsonDicHelper.getJsonDicValue(jsonDic, key: "city")
        self.area = JsonDicHelper.getJsonDicValue(jsonDic, key: "area")
        self.recommendInfo = JsonDicHelper.getJsonDicValue(jsonDic, key: "recommend_info")
        self.inviteOpenStoreURL = JsonDicHelper.getJsonDicValue(jsonDic, key: "invite_openstore_url")
        self.facePayURL = JsonDicHelper.getJsonDicValue(jsonDic, key: "facepay_url")
        self.binded_user = JsonDicHelper.getJsonDicValue(jsonDic, key: "binded_user")
        
        let idImagesArray = JsonDicHelper.getJsonDicValue(jsonDic, key: "id_images")
//        pprLog(message: "\(idImagesArray)")
        let myArray2 = idImagesArray.componentsSeparatedByString(",")
        for item in myArray2 {
//            pprLog(message: "\(item)")
            self.idIamges.append(item)
        }
        

        let cityDic = JsonDicHelper.getJsonDicDictionary(jsonDic, key: "city_info")
        self.cityModel = CityInfoModel(jsonDic: cityDic)
        self.status = JsonDicHelper.getJsonDicValue(jsonDic, key: "status")
        
        self.purchase_url = JsonDicHelper.getJsonDicValue(jsonDic, key: "purchase_url")

        super.init()
    }
}

class CityInfoModel:NSObject {
    var city_locationid:String = ""
    var city_name:String = ""
    var longitude:String = ""
    var latitude:String = ""
    var areaList = [AreaModel]()
    
    override init() {
        super.init()
    }
    
    init(jsonDic:Dictionary<String,AnyObject>){
        self.city_locationid = JsonDicHelper.getJsonDicValue(jsonDic, key: "city_locationid")
        self.city_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "city_name")
        self.longitude = JsonDicHelper.getJsonDicValue(jsonDic, key: "longitude")
        self.latitude = JsonDicHelper.getJsonDicValue(jsonDic, key: "latitude")
        //area数组
        let areaArray = JsonDicHelper.getJsonDicArray(jsonDic, key: "area")
        for item in areaArray {
            if item is Dictionary<String,AnyObject>{
                let area = AreaModel(jsonDic: item as! Dictionary<String, AnyObject>)
                self.areaList.append(area)
            }
        }
        super.init()
    }
}

class AreaModel:NSObject {
    var area_locationid:String = ""
    var area_name:String = ""
    var longitude:String = ""
    var latitude:String = ""
    
    override init(){
        super.init()
    }
    
    init(jsonDic:Dictionary<String,AnyObject>){
        self.area_locationid = JsonDicHelper.getJsonDicValue(jsonDic, key: "area_locationid")
        self.area_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "area_name")
        self.longitude = JsonDicHelper.getJsonDicValue(jsonDic, key: "longitude")
        self.latitude = JsonDicHelper.getJsonDicValue(jsonDic, key: "latitude")
        super.init()
    }
}