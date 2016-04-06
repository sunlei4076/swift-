//
//  FeedGoodView.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/8/24.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class FeedGoodView: UIView,UIAlertViewDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    private var imageUrl:String = ""
    private var title:String = ""
    private var tapUrl:String = ""
    private var needPostStoreId:Bool = false
    var webViewType = ""
    
    class func instantiateFromNib() -> FeedGoodView {
        let view = UINib(nibName: "FeedGoodView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! FeedGoodView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }
    
    func initData(imageUrl:String, title:String, tapUrl:String, postStoreId:Bool){
        self.imageUrl = imageUrl
        self.title = title
        self.tapUrl = tapUrl
        self.needPostStoreId = postStoreId
        self.titleLabel.text = self.title;
        self.feedImage.setImageWithURL(NSURL(string: self.imageUrl)!, placeholderImage: UIImage(named: "PlaceHolder"))
    }
    
    private func initControl(){
        self.titleLabel.numberOfLines = 3
        self.titleLabel.font = GGetNormalCustomFont()
    }
    
    @IBAction func tapAction(sender: AnyObject) {

       
        
//        if  LoginInfoModel.sharedInstance.m_auth.isEmpty{
//            // 判断是否登录,
//            
//            let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            let rootVC = app.window?.rootViewController
//            
//            rootVC?.presentViewController(loginVC, animated: true, completion: nil)
//            
// let lastAccount = LoginAccountTool.getLastLoginAccount()
//            
//            if lastAccount.name.isEmpty{
        
//        // 判断是否登录,
//        let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
//        //更新登陆界面1202
//        loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
//        
//        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController?.presentViewController(loginVC, animated: true, completion: nil)
        
//            }else{
//              pprLog("未登录")
//            }
            
          

//        }else{
            if LoginInfoModel.sharedInstance.shopStatus == "3" || LoginInfoModel.sharedInstance.shopStatus == "-1" {
                
                if LoginInfoModel.sharedInstance.m_auth.isEmpty{
                    // 判断是否登录,
                    let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
                    //更新登陆界面1202
                    loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
                    
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController?.presentViewController(loginVC, animated: true, completion: nil)
                }else{
                    //弹出提交店铺页面
                    let popover = OpenShopPopover.instantiateFromNib()
                    popover.show({ () -> () in
                        let register = RegisteriPhoneIdentifyController(nibName:"RegisteriPhoneIdentifyController", bundle:nil)
                        register.hidesBottomBarWhenPushed = true
                        let navVC = ProjectManager.sharedInstance.getTabSelectedNav()
                        navVC.pushViewController(register, animated: true)
                    })
                }
                
                
            }else if LoginInfoModel.sharedInstance.shopStatus == "0" {
                
                if LoginInfoModel.sharedInstance.m_auth.isEmpty{
                    // 判断是否登录,
                    let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
                    //更新登陆界面1202
                    loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
                    
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController?.presentViewController(loginVC, animated: true, completion: nil)
                }else{
                
                    let alert = UIAlertView(title: "提示", message: "亲，您的店铺正在审核中", delegate: self, cancelButtonTitle: "联系客服", otherButtonTitles: "我知道了")
                    alert.show()
                }
                
                
            }else if LoginInfoModel.sharedInstance.shopStatus == "4"{
                if LoginInfoModel.sharedInstance.m_auth.isEmpty{
                    // 判断是否登录,
                    let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
                    //更新登陆界面1202
                    loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
                    
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController?.presentViewController(loginVC, animated: true, completion: nil)
                }else{
                    let alert = UIAlertView(title: "提示", message: "店铺审核不通过", delegate: self, cancelButtonTitle: "重新申请", otherButtonTitles: "我知道了")
                    alert.show()
                }
                
                
            }else{
                
                if ProjectManager.sharedInstance.checkHasLogin() == true{
                    let webVC = WebViewController()
                    webVC.title = self.title
                    //            if self.needPostStoreId == false{
                    //                webVC.webUrl = self.tapUrl
                    //            }else{
                    let request = NSMutableURLRequest(URL: NSURL(string: tapUrl)!)
                    //使用POST请求传参storeId
                    request.HTTPMethod = "POST"
                    let storeId = LoginInfoModel.sharedInstance.store.store_id
                    pprLog(storeId)
                    request.HTTPBody = "store_id=\(storeId)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    webVC.webRequest = request
                    //            }
                    
                    webVC.hidesBottomBarWhenPushed = true
                    
                    let selectVC = ProjectManager.sharedInstance.getTabSelectedNav()
                    selectVC.pushViewController(webVC, animated: true)
                }
                
            }

//    }
}
    
    // MARK:- alertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let buttonStr = alertView.buttonTitleAtIndex(buttonIndex)
        if buttonStr == "联系客服" {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://4000588577")!)
        }
        else if buttonStr == "重新申请"{
            let setShopInfo = SetShopInfoViewController(nibName:"SetShopInfoViewController", bundle:nil)
            setShopInfo.hidesBottomBarWhenPushed = true
//            self.navigationController!.pushViewController(setShopInfo, animated: true)
            let VC = ProjectManager.sharedInstance.getTabSelectedNav()
            
            VC.pushViewController(setShopInfo, animated: true)
            
        }
    }
}