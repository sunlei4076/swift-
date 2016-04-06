//
//  LoginViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/9.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

public enum showType : Int{
    case login //登录
    case logout //退出
    case add //添加账号
}

class LoginViewController: UIViewController, UIKeyboardViewControllerDelegate {
    
    @IBOutlet weak var inputAccount: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var weixinLoginBtn: UIButton!
    
    //    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //标识显示类型，0：登录， 1：退出，2：添加账号//
    var status:showType = showType.login
    var showLastLoginInfo:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .Custom
        
        
        self.initControl()
        self.initData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.keyboard.boardDelegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.keyboard.boardDelegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    private func initControl(){
        
        //添加手势
        let tapLogic: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "logicTapAction")
        self.view.addGestureRecognizer(tapLogic)
        //设置button边框
        self.loginBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.loginBtn.layer.borderWidth = 1.0/UIScreen.mainScreen().scale
        self.weixinLoginBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.weixinLoginBtn.layer.borderWidth = 1.0/UIScreen.mainScreen().scale;
        
        //设置字体
        self.loginBtn.titleLabel?.font = GGetBigCustomFont()
        self.inputAccount.font = GGetNormalCustomFont()
        self.inputPassword.font = GGetNormalCustomFont()
    }
    
    //如果被挤下去的时候账号密码的输入框会显示账号密码
    private func initData(){
        if showLastLoginInfo == true{
            let lastLoginAccount = LoginAccountTool.getLastLoginAccount()
            self.inputAccount.text = lastLoginAccount.name
            self.inputPassword.text = lastLoginAccount.password
        }
    }
    
    func logicTapAction(){
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    //    func autoLogin(name:String,password:String){
    //        self.inputAccount.text = name
    //        self.inputPassword.text = password
    //        self.toLoginAction(self.loginBtn)
    //    }
    
    @IBAction func toLoginAction(sender: AnyObject) {
        //非空检查
        let account = self.inputAccount.text;
        let password = self.inputPassword.text;
        
        if(account!.isEmpty){
            GShowAlertMessage("请输入账号！")
            return
        }
        if(password!.isEmpty){
            GShowAlertMessage("请输入密码！")
            return
        }
        let window = UIApplication.sharedApplication().keyWindow
        let hud = MBProgressHUD.showHUDAddedTo(window, animated: true)
        //接口调用
        let networkMan = NetworkManager.sharedInstance
        networkMan.requestLogin(account!, password: password!, success: { (jsonDic:AnyObject) -> () in
            //成功
            //登录环信
            self.easeMobLoginOut({ () -> () in
                //环信退出登录成功
                //保存账号信息
                self.saveInfo(account!,password: password!,jsonDic:jsonDic)
                //环信登录
                ProjectManager.sharedInstance.loginToHX({ () -> () in
                    //环信登录成功进入首页
                    hud.hide(true)
                    let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UITabBarController
                    UIApplication.sharedApplication().delegate?.window?!.rootViewController = mainVC
                })
            })
            }) { (error:String, needRelogin:Bool) -> () in
                //失败
                hud.hide(true)
                //自己服务器登录失败
                GShowAlertMessage(error+".")
                //                if needRelogin == true{
                //                    //需要重新登录
                //                    //do nothing
                //                }else{
                //                    //失败
                //                    GShowAlertMessage(error)
                //                }
        }
    }
    
    func saveInfo(account:String,password:String,jsonDic:AnyObject){
        let dic = jsonDic as! Dictionary<String, AnyObject>
        let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
        let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
        LoginInfoModel.sharedInstance.setDataWithJson(objDic)
        //保存账号
        let account = AccountInfo(loginUser: LoginInfoModel.sharedInstance, password: password)
        let accountTool = LoginAccountTool()
        accountTool.saveAccount(account)
        LoginAccountTool.saveLastLoginAccount(account)
    }
    
    
    //环信推出
    func easeMobLoginOut(successBlock:()->()){
        EaseMob.sharedInstance().chatManager.asyncLogoffWithCompletion!({ (let dic, let error) -> Void in
            if (error != nil) {
                let window = UIApplication.sharedApplication().keyWindow
                MBProgressHUD.hideHUDForView(window, animated: false)
                GShowAlertMessage(error.description+"..")
            }else{
                successBlock()//登录成功的回调
            }
            }, onQueue: nil)
    }
    
    
    @IBAction func toFeedTab(sender: AnyObject){
        if self.status == showType.logout{
            //退出登录时，需要刷新状态
            NSNotificationCenter.defaultCenter().postNotificationName("ChangeLogin", object: self)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func toWeiXinLogin(sender: UIButton) {
        //微信登陆
        WXApiTool.sharedInstance.sendAuthRequest({ (jsonDic:AnyObject) -> () in
            //成功
            //HX帐号注销
            self.easeMobLoginOut({ () -> () in
                let dic = jsonDic as! Dictionary<String, AnyObject>
                let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                LoginInfoModel.sharedInstance.setDataWithJson(objDic)
                //环信
                ProjectManager.sharedInstance.loginToHX({ () -> () in
                    //跳转到主页
                    self.dismissViewControllerAnimated(true, completion: nil)
                    //                    let rootVC = ProjectManager.sharedInstance.getRootTab()
                    //                    if rootVC.selectedIndex != 0{
                    //                        rootVC.selectedIndex = 0
                    //                    }
                    let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UITabBarController
                    
                    UIApplication.sharedApplication().delegate?.window!!.rootViewController = mainVC
                    
                })
            })
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    //需要重新登录
                    //do nothing
                }else{
                    //失败
                    GShowAlertMessage(error)
                }
        })
    }
    
}
