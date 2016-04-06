//
//  RegisterModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/1.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class RegisterModel: NSObject {
    
    //认证信息
    var mAuth:String = ""
    //用户名
    var userName:String = ""
    //密码
    var password:String = ""
    //商铺类别
    var cate_id:String = ""
    //商铺名称
    var stroe_name:String = ""
    //店长姓名
    var real_name:String = ""
    //商铺所在省份
    var province:String = ""
    //商铺所在城市
    var city:String = ""
    //商铺所在地区（县）
    var area:String = ""
    //商铺地址的经度
    var lng:String = ""
    //商铺地址的纬度
    var lat:String = ""
    //联系电话
    var tel:String = ""
    //店铺地址
    var address:String = ""
    
    //覆盖范围
    var radius:String = ""
    
    //头像
    var headIcon:UIImage?
    //证件照片
    var cardImage:[UIImage] = []
    //店铺公告；
    var description_t:String = ""
    //招牌图片；
    var store_banner:UIImage?
    //推荐人；
    var recommendInfo:String = ""
    
}
