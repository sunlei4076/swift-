//
//  NotificationViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/19.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UIAlertViewDelegate {

    @IBOutlet weak var bordView: UIView!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
        self.initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initControl(){
        self.title = "发送到货提醒"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        
        //设置字体
        self.textView.font = GGetNormalCustomFont()
        self.commitBtn.backgroundColor = GlobalStyleFontColor
        self.commitBtn.titleLabel?.font = GGetNormalCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        //do nothing
    }

    @IBAction func actionCommit(sender: AnyObject) {
        let alert = UIAlertView(title: "提示", message: "您是否确定群发已到货通知？", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex{
            NetworkManager.sharedInstance.requestNotification({ (jsonDic:AnyObject) -> () in
                GShowAlertMessage("已短信通知所有买家！")
                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                    
                    }else{
                        GShowAlertMessage(error)
                    }
            })
        }
    }
}
