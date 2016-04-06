//
//  SetViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/11.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class SetViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {

    @IBOutlet weak var topInfoView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showAddressLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    
    @IBOutlet weak var addressTipLabel: UILabel!
    @IBOutlet weak var phoneTipLabel: UILabel!
    @IBOutlet weak var showPhoneLabel: UILabel!
    
    @IBOutlet weak var showHeadIconImage: UIImageView!
    
    @IBOutlet weak var nextBtn: UIButton!
    private var tableData:[String] = [] //"更改覆盖范围","账号密码修改",
    
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
        self.title = "设置"
        
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.showNameLabel.textColor = GlobalStyleFontColor
        self.addressTipLabel.textColor = GlobalGrayFontColor
        self.phoneTipLabel.textColor = GlobalGrayFontColor
        self.nextBtn.backgroundColor = GlobalStyleButtonColor
        
        //设置字体
        GSetFontInView(self.topInfoView, font: GGetNormalCustomFont())
        self.showNameLabel.font = GGetCustomFontWithSize(GBigFontSize+2)
        self.nextBtn.titleLabel?.font = GGetBigCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        let loginInfo = LoginInfoModel.sharedInstance
        
        if (loginInfo.shopStatus as NSString).intValue == -1 {
            self.tableData = ["问题反馈", "关于我们"]
        }else{
            self.tableData = ["账号密码修改", "问题反馈", "关于我们"]
        }
        
        self.showNameLabel.text = loginInfo.store.store_name
        self.showAddressLabel.text = loginInfo.address.isEmpty ? "未设置" : loginInfo.address
        self.showPhoneLabel.text = loginInfo.mobile.isEmpty ? "未设置":loginInfo.mobile
        let url = NSURL(string: loginInfo.store.store_logo)
        self.showHeadIconImage.setImageWithURL(url!, placeholderImage: UIImage(named: "PlaceHolder"))
    }
    
//    @IBAction func actionNext(sender: AnyObject) {
//        //账户管理
//        let accountManageVC = LoginAccountsViewController(nibName:"LoginAccountsViewController",bundle:nil)
//        self.navigationController?.pushViewController(accountManageVC, animated: true)
//    }
    
    //登出
    @IBAction func actionLoginOut(sender: AnyObject) {
        let window = UIApplication.sharedApplication().keyWindow
        MBProgressHUD.showHUDAddedTo(window, animated: true)
        self.easeMobLoginOut { () -> () in
            self.serverLoginOut()
        }
    }
    
    //自己服务器退出
    func serverLoginOut(){
        NetworkManager.sharedInstance.requestLogOut({ (jsonDic:AnyObject) -> () in
            
            LoginInfoModel.sharedInstance.m_auth = ""//清除token？
            LoginAccountTool.clearLastLoginAccount()//清除账号
            
            let rootVC = ProjectManager.sharedInstance.getRootTab()
            let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
            let newRootVC = NoLoginViewController()
            let newRootNav = UINavigationController.init(rootViewController: newRootVC)
            loginVC.showLastLoginInfo = true
            loginVC.status = showType.logout
            //更新登陆界面1202
            loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
            rootVC.presentViewController(newRootNav, animated: true) { () -> Void in
                self.navigationController?.popToRootViewControllerAnimated(false)
                rootVC.selectedIndex = 0
            }
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true {
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }
    
    func easeMobLoginOut(successBlock:()->()){
        EaseMob.sharedInstance().chatManager.asyncLogoffWithCompletion!({ (let dic, let error) -> Void in
            if (error != nil) {
                let window = UIApplication.sharedApplication().keyWindow
                MBProgressHUD.hideHUDForView(window, animated: false)
                GShowAlertMessage(error.description)
            }else{
                successBlock()
            }
            }, onQueue: nil)
    }

    
    
    
    //跳转到店铺设置；
    @IBAction func setShopInfo() {
        if LoginInfoModel.sharedInstance.shopStatus == "1" {
            let setShopInfo = SetShopInfoViewController(nibName:"SetShopInfoViewController", bundle:nil)
            setShopInfo.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(setShopInfo, animated: true)
        }
        else if LoginInfoModel.sharedInstance.shopStatus == "0" {
            let alert = UIAlertView(title: "提示", message: "亲，您的店铺正在审核中", delegate: self, cancelButtonTitle: "联系客服", otherButtonTitles: "我知道了")
            alert.show()
        }
        else if LoginInfoModel.sharedInstance.shopStatus == "4" {
            let alert = UIAlertView(title: "提示", message: "店铺审核不通过", delegate: self, cancelButtonTitle: "重新申请", otherButtonTitles: "我知道了")
            alert.show()
            
        }
        
        
    }
   // MARK:- alertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let buttonStr = alertView.buttonTitleAtIndex(buttonIndex)
        if buttonStr == "重新申请"{
            let setShopInfo = SetShopInfoViewController(nibName:"SetShopInfoViewController", bundle:nil)
            setShopInfo.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(setShopInfo, animated: true)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell")
        if cell == nil{
            cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
            cell!.selectionStyle = UITableViewCellSelectionStyle.Gray
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textLabel?.font = GGetNormalCustomFont()
        }
        
        cell!.textLabel!.text = self.tableData[indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let title = self.tableData[indexPath.row]
        if title == "账号密码修改"{
            let statusInt = (LoginInfoModel.sharedInstance.shopStatus as NSString).integerValue
            if statusInt == 1{
                //已开店
                let hasBind = LoginInfoModel.sharedInstance.store.binded_user
                if (hasBind as NSString).integerValue == 0{
                    //未绑定
                    let changePassword = AccountAndWordChangeView.instantiateFromNib()
                    changePassword.show(1)
                }else{
                    //已绑定
                    let changePassword = AccountAndWordChangeView.instantiateFromNib()
                    changePassword.show(2)
                }
            }else if statusInt == 0{
                //待审核
                GShowAlertMessage("店铺审核中！")
            }else if statusInt == 4{
                //审核不通过
                GShowAlertMessage("店铺审核不通过！")
            }
        }else if title == "问题反馈"{
            let sendQuestionVC = SendQuestionViewController(nibName:"SendQuestionViewController", bundle:nil)
            sendQuestionVC.showType = 2
            self.navigationController?.pushViewController(sendQuestionVC, animated: true)
        }else if title == "关于我们"{
            let aboutVC = AboutUsViewController(nibName:"AboutUsViewController", bundle:nil)
            self.navigationController?.pushViewController(aboutVC, animated: true)
        }
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
