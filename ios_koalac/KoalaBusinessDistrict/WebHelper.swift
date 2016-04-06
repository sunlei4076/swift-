//
//  webHelper.swift
//  KoalaBusinessDistrict
//
//  Created by seekey on 15/9/19.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class webHelper: NSObject {
    
    static func openWebVC(jumpTitle: String, jumpURL: String) ->WebViewController {
        let webVC = WebViewController()
        webVC.hidesBottomBarWhenPushed = true
        webVC.title = jumpTitle
        let request = NSMutableURLRequest(URL: NSURL(string: jumpURL)!)
        //使用POST请求传参storeId
        request.HTTPMethod = "POST"
        let storeId = LoginInfoModel.sharedInstance.store.store_id
        request.HTTPBody = "store_id=\(storeId)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        webVC.webRequest = request
        return webVC
    }
    //用于我要进货； WebViewToJSController
    static func openAppointWebVC(jumpTitle: String, jumpURL: String, param1: String, param2: String) ->WebViewToJSController {
        let webVC = WebViewToJSController()
        webVC.hidesBottomBarWhenPushed = true
        webVC.title = jumpTitle
        let request = NSMutableURLRequest(URL: NSURL(string: jumpURL)!)
        //使用POST请求传参storeId
        request.HTTPMethod = "POST"
        let param3 = LoginInfoModel.sharedInstance.m_auth
        let params = "kstore_id=" + param1 + "&" + "user_device_type=" + param2 + "&" + "m_auth=" + param3
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        webVC.webRequest = request
        return webVC
    }
    
    static func openWebShareVC(jumpTitle: String, jumpURL: String) ->WebViewShareController {
        let webShareVC = WebViewShareController()
        webShareVC.hidesBottomBarWhenPushed = true
        webShareVC.title = jumpTitle
        let request = NSMutableURLRequest(URL: NSURL(string: jumpURL)!)
        //使用POST请求传参storeId
        request.HTTPMethod = "POST"
        let storeId = LoginInfoModel.sharedInstance.store.store_id
        pprLog(storeId)
        request.HTTPBody = "store_id=\(storeId)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        webShareVC.webShareRequest = request
        
//        pprLog(jumpURL)
        if #available(iOS 8.0, *) {
            if (jumpURL as NSString).containsString("?") {
                webShareVC.webShareUrl = jumpURL + "&share_from=app"
            }else {
                webShareVC.webShareUrl = jumpURL + "?share_from=app"
            }
        } else {
            webShareVC.webShareUrl = jumpURL + "&share_from=app"
        }
        pprLog(jumpURL)
        
        return webShareVC
    }

    

}
