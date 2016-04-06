//
//  MallCateModel.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/8/27.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

/*商城类别*/

import UIKit

class MallCateModel: NSObject {
    //类别ID
    var cate_id:String = ""
    //类别名称
    var cate_name:String = ""
    //子类别
    var nextCateArray:[MallCateModel] = []
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.cate_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_id")
        self.cate_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_name")
        
        let secondArray = JsonDicHelper.getJsonDicArray(jsonDic, key: "second_cates")
        for item in secondArray{
            if item is Dictionary<String,AnyObject>{
                let secondCate = MallCateModel()
                secondCate.secondeCateInit(item as! Dictionary<String,AnyObject>)
                self.nextCateArray.append(secondCate)
            }
        }
    }
    
    private func secondeCateInit(jsonDic:Dictionary<String,AnyObject>){
        self.cate_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_second_id")
        self.cate_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_second_name")
        
        let thirdArray = JsonDicHelper.getJsonDicArray(jsonDic, key: "third_cates")
        for item in thirdArray{
            if item is Dictionary<String,AnyObject>{
                let thirdCate = MallCateModel()
                thirdCate.thirdCateInit(item as! Dictionary<String,AnyObject>)
                self.nextCateArray.append(thirdCate)
            }
        }
    }
    
    private func thirdCateInit(jsonDic:Dictionary<String,AnyObject>){
        self.cate_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_third_id")
        self.cate_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_third_name")
    }
}
