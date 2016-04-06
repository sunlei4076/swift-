//
//  MainTabViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/26.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController, UITabBarControllerDelegate,EMChatManagerDelegate {

    var discoveryNum:Int = 0 {
        didSet{
            
            let discoverVC = DiscoveryTableViewController(nibName: "DiscoveryTableViewController",  bundle: nil)
            
            let num =  discoverVC.clearDiscoveryNum(discoveryNum)

            self.discoveryNum = num
             if self.discoveryNum == 0 {
                self.hideDiscoveryRedDot()
            }else{
                self.showDiscoveryRedDot()
            }
        }
    }
    private let discoveryRedDot:UIImageView = UIImageView()
    
    override func loadView() {
        super.loadView()
        
        let image = UIImage(named: "TabUpdateDot")
        self.discoveryRedDot.image = image
        self.discoveryRedDot.frame = CGRectMake(0, 0, image!.size.width, image!.size.height)
        self.discoveryRedDot.hidden = true
        self.tabBar.addSubview(self.discoveryRedDot)
        
        self.showDiscoveryRedDot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = GGetColor(235.0, g: 66.0, b: 74.0)
        self.tabBar.translucent = false
        self.easeMob()//设置环信代理
         NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateData"), name: "ChangeLogin", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.updateData()
    }
    
    private func easeMob(){
    EaseMob.sharedInstance().chatManager.removeDelegate(self)
    EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
    }
    
    //MARK: - 环信未读消息数回调delegate
    func didUnreadMessagesCountChanged()
    {
        self.newsVCRefresh()
    }
    
    func newsVCRefresh(){
        for vc:UIViewController in (self.viewControllers![0] as! UINavigationController).viewControllers{
            if vc.isKindOfClass(NewsViewController){
                (vc as! NewsViewController).refreshEaseMob()
            }
        }
    }

    func customerVCRefresh(){
        for vc:UIViewController in (self.viewControllers![1] as! UINavigationController).viewControllers{
            if vc.isKindOfClass(CustomerViewController){
                (vc as! CustomerViewController).dataList()
            }
        }
    }


    //MARK: - 环信接受消息回调
    func didReceiveMessage(message: EMMessage!) {
        //pprLog(message)
        
        let state = UIApplication.sharedApplication().applicationState
        if state == UIApplicationState.Background {
            let hx_messageBodies = message.messageBodies.first
            let mesBody = hx_messageBodies as! EMTextMessageBody
            let mexHX = message.ext
            let mesStr = mesBody.text
            let userName = mexHX["nickname"] as! String
            
            let notiHX = UILocalNotification()
            notiHX.fireDate = NSDate()
            notiHX.alertBody = userName + ":" + mesStr
//            notiHX.alertBody = "本地" + userName + ":" + mesStr
            var userInfoer = [String: AnyObject]()
            userInfoer["hxid"] = message.from
            userInfoer["userName"] = userName
            
            let hxid = message.from
            let index = hxid.startIndex.advancedBy(3)
            let useid  = hxid.substringFromIndex(index)
            pprLog(useid)
            userInfoer["uid"] = useid
            notiHX.userInfo = userInfoer
            notiHX.soundName = UILocalNotificationDefaultSoundName
            //pprLog(notiHX.alertBody)
            UIApplication.sharedApplication().scheduleLocalNotification(notiHX)
            return
        }

    }
    
    
    func showDiscoveryRedDot(){
        if self.discoveryRedDot.hidden == true{
            let screenWidth = UIScreen.mainScreen().bounds.width
            let itemWidth = screenWidth/4
            var frame = self.discoveryRedDot.frame
            frame.origin.y = 8
            frame.origin.x = 2.0 * itemWidth + itemWidth/2+10
            self.discoveryRedDot.frame = frame
            self.discoveryRedDot.hidden = false
        }
    }
    
    func hideDiscoveryRedDot(){
        if self.discoveryRedDot.hidden == false{
            self.discoveryRedDot.hidden = true
        }
    }
    
    private func updateNewsTotal(){
        //bar item 右上脚未读消息数量
        if self.viewControllers?.count > 2{
            let vc = self.viewControllers?[1]
            //华丽分割线
            if vc!.tabBarItem.badgeValue == nil{
                vc!.tabBarItem.badgeValue = nil
            }else{
                vc!.tabBarItem.badgeValue = String(Int(vc!.tabBarItem.badgeValue!)!)
            }

        }
    }

    private func updateDiscoveryTotal(){
        //发现
        NetworkManager.sharedInstance.requestDiscoveryUpdate({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            var total = 0
            for item in listArray{
                if item is Dictionary<String, AnyObject>{
                    let itemDic = item as! Dictionary<String, AnyObject>
                    let newest_id = JsonDicHelper.getJsonDicValue(itemDic, key: "newest_id")
                    total += (newest_id as NSString).integerValue
                }
            }
            self.discoveryNum = total
            
            if total > 0 {
                self.discoveryRedDot.hidden = false
            }
            
            }, fail: { (error:String, needRelogin:Bool) -> () in
                
        })
    }

    
    func updateData(){
        if LoginInfoModel.sharedInstance.m_auth.isEmpty{
            /*
            let discoveryVC = self.viewControllers?[2] as! UIViewController
            discoveryVC.tabBarItem.badgeValue = nil*/
            self.discoveryNum = 0
            
            let newVC = self.viewControllers?[1]
            newVC!.tabBarItem.badgeValue = nil
        }else{
            self.customerVCRefresh()
            self.newsVCRefresh()
            self.updateNewsTotal()
            self.updateDiscoveryTotal()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
  
}

