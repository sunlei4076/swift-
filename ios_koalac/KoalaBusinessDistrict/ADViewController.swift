//
//  ADViewController.swift
//  KoalaBusinessDistrict
//
//  Created by Adobe on 15/11/19.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit
//点击叉掉广告时回调等级积分弹框
    var levelModelInfoBlock:(()->())?
class ADViewController: UIViewController {

var  advertisingM:advertisingModel = advertisingModel()

    @IBOutlet weak var buttonImg: UIButton!

    @IBOutlet weak var clickBtn: UIButton!

    override func viewDidLoad() {

          super.viewDidLoad()
          self.modalPresentationStyle = .Custom
//        self.clickBtn.layer.cornerRadius = 15
//        self.clickBtn.layer.masksToBounds = true
        //判断设备
        if screenHeight < 500 { //4s
            self.buttonImg.setImageForState(UIControlState.Normal, withURL: NSURL(string: self.advertisingM.image_small)!)
        }else if screenHeight > 700 { //6Ps
            self.buttonImg.setImageForState(UIControlState.Normal, withURL: NSURL(string: self.advertisingM.image_big)!)
        }else {
            //中图
            self.buttonImg.setImageForState(UIControlState.Normal, withURL: NSURL(string: self.advertisingM.image_medium)!)
        }
        }
   //点击图片跳URL
    @IBAction func imageClick() {
        
        self.JPushJumpToWeb("", jumpURL: self.advertisingM.ad_url)
        self.clickAdtistRequsetNet()
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //叉掉图片
    @IBAction func btnClick() {

        self.dismissViewControllerAnimated(true, completion: nil)
        if levelModelInfoBlock != nil
        {
            levelModelInfoBlock!()
        }else{
             ProjectManager.sharedInstance.versionCheck()
        }


    }

    func JPushJumpToWeb(jumpTitle: String, jumpURL: String) {

        let webJPushVC = webHelper.openWebVC(jumpTitle, jumpURL:jumpURL)
        let navVC = ProjectManager.sharedInstance.getTabSelectedNav()
        //必须点的图片点击之后设置1
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("1", forKey: "clickIndex")
           defaults.synchronize()
            webJPushVC.advistEntry = "广告"
        navVC.pushViewController(webJPushVC, animated: true)
    }
  
    //点击广告增量
    private func clickAdtistRequsetNet(){
        NetworkManager.sharedInstance.requestAdvertisingClickNumbe(self.advertisingM.ad_id, success:{ (jsonDic:AnyObject) -> () in
            pprLog("点击广告增量成功")
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                }else{
                    pprLog("点击广告增量失败")
                }
        })
    }
}
