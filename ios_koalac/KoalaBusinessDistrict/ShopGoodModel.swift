//
//  ShopGoodModel.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/15.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

//店铺商品model
class ShopGoodModel: NSObject {
    //*********/
    var good_num:Int = 0
    //*********/
    
    var goods_id:String = ""
    //商品名称
    var goods_name:String = ""
    var cate_id:String = ""
    //商品类目
    var cate_name:String = ""
    //商品类目
    var cateSecendId:String = ""
    //商品类目
    var cateThridId:String = ""
    //上架/下架
    var if_show:String = ""
    //库存
    var stock:String = ""
    //优惠价
    var price:String = ""
    //原价
    var orige_price:String = ""
    //建议零售价（批发商用）
    var retail_price:String = ""
    //时间
    var add_time:String = ""
    //商品图片
    var default_image:String = ""
    //商品详情URL
    var goods_url:String = ""
    //商品封面图片
    var goodCoverImages:[goodCoverImageModel] = []
    //商品描述图片
    var goodDescripImages:[String] = []
    //商品描述
    var goodDescription:String = ""
    //本店分类ID
    var shopCate_id:String = ""
    //本店分类名称
    var shopCate_name:String = ""
    
    var qrcode_goods_url:String = ""
    
    //进货商品发布时订单ID
    var order_rec_id:String = ""
    
    /*未使用
    var store_id:String = ""
    var smallshop_id:String = ""
    var brand:String = ""
    var closed:String = ""
    var recommended:String = ""
    var spec_id:String = ""
    var store_name:String = ""
    var views:String = ""
    var sales:String = ""
    var comments:String = ""
    */
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.goods_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "goods_id")
        self.goods_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "goods_name")
        self.cate_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_id")
        self.cate_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_name")
        self.if_show = JsonDicHelper.getJsonDicValue(jsonDic, key: "if_show")
        self.stock = JsonDicHelper.getJsonDicValue(jsonDic, key: "stock")
        self.price = JsonDicHelper.getJsonDicValue(jsonDic, key: "price")
        self.orige_price = JsonDicHelper.getJsonDicValue(jsonDic, key: "orige_price")
        self.retail_price = JsonDicHelper.getJsonDicValue(jsonDic, key: "retail_price")
        self.add_time = JsonDicHelper.getJsonDicValue(jsonDic, key: "add_time")
        self.default_image = JsonDicHelper.getJsonDicValue(jsonDic, key: "default_image")
        let detailDic = JsonDicHelper.getJsonDicDictionary(jsonDic, key: "detail")
        self.cateSecendId = JsonDicHelper.getJsonDicValue(detailDic, key: "cate_second_id")
        self.cateThridId = JsonDicHelper.getJsonDicValue(detailDic, key: "cate_third_id")
        self.goods_url = JsonDicHelper.getJsonDicValue(detailDic, key: "goods_url")
        self.qrcode_goods_url = JsonDicHelper.getJsonDicValue(detailDic, key: "qrcode_goods_url")
        self.order_rec_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "order_rec_id")
        pprLog(self.order_rec_id)
        self.shopCate_id = JsonDicHelper.getJsonDicValue(detailDic, key: "scates_id")
        self.goodDescription = JsonDicHelper.getJsonDicValue(detailDic, key: "description")
        let imagesArray = JsonDicHelper.getJsonDicArray(detailDic, key: "_images")
        for item in imagesArray{
            if item is Dictionary<String, AnyObject>{
                let imageModel = goodCoverImageModel(jsonDic: (item as! Dictionary<String,AnyObject>))
                self.goodCoverImages.append(imageModel)
            }
        }
        
        let descriptionArray = JsonDicHelper.getJsonDicArray(detailDic, key: "_description_images")
        for item in descriptionArray{
            if item is Dictionary<String, AnyObject>{
                let imageUrl = JsonDicHelper.getJsonDicValue((item as! Dictionary<String,AnyObject>), key: "image_url")
                if imageUrl.isEmpty == false{
                    self.goodDescripImages.append(imageUrl)
                }
            }
        }
        
        /*未使用
        self.store_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_id")
        self.smallshop_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "smallshop_id")
        self.brand = JsonDicHelper.getJsonDicValue(jsonDic, key: "brand")
        self.closed = JsonDicHelper.getJsonDicValue(jsonDic, key: "closed")
        self.recommended = JsonDicHelper.getJsonDicValue(jsonDic, key: "recommended")
        self.spec_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "spec_id")
        self.store_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "store_name")
        self.views = JsonDicHelper.getJsonDicValue(jsonDic, key: "views")
        self.sales = JsonDicHelper.getJsonDicValue(jsonDic, key: "sales")
        self.comments = JsonDicHelper.getJsonDicValue(jsonDic, key: "comments")
        */
    }
}

//商品封面图片model
class goodCoverImageModel:NSObject{
    var image_url:String = ""
    var file_id:String = ""
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.image_url = JsonDicHelper.getJsonDicValue(jsonDic, key: "image_url")
        self.file_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "file_id")
    }
}

//店铺商品分类model
class ShopTypeModel:NSObject{
    
    var cate_id:String = ""
    var cate_name:String = ""
    var pic:String = ""
    var sort_order:String = ""
    var if_show:String = ""
    var goods_num:String = ""
    
    convenience init(jsonDic:Dictionary<String,AnyObject>){
        self.init()
        self.cate_id = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_id")
        self.cate_name = JsonDicHelper.getJsonDicValue(jsonDic, key: "cate_name")
        self.pic = JsonDicHelper.getJsonDicValue(jsonDic, key: "pic")
        self.sort_order = JsonDicHelper.getJsonDicValue(jsonDic, key: "sort_order")
        self.if_show = JsonDicHelper.getJsonDicValue(jsonDic, key: "if_show")
        self.goods_num = JsonDicHelper.getJsonDicValue(jsonDic, key: "goods_num")
    }
}