//
//  BuyGoodsModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/9.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class BuyGoodsModel: NSObject {
    var good:ShopGoodModel = ShopGoodModel()
    var buyNum:Int = 0
    var isSelect:Bool = false
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.good = ShopGoodModel(jsonDic: jsonDic)
        self.buyNum = 0
        self.isSelect = false
    }
}
