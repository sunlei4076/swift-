//
//  LoginAccountsViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/1.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class LoginAccountsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var loginOutBtn: UIButton!
    @IBOutlet var tableFootView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var tableData:[AccountInfo] = []
    
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
        self.title = "账号管理"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.tableFooterView = self.tableFootView
        self.tableView.registerNib(UINib(nibName: "LoginAccountCell", bundle: nil), forCellReuseIdentifier: LoginAccountCell.cellIdentifier())
        
        self.loginOutBtn.backgroundColor = GlobalStyleButtonColor;
        
        //设置字体
        GSetFontInView(self.tableFootView, font: GGetNormalCustomFont())
        self.loginOutBtn.titleLabel?.font = GGetBigCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        let accountTool = LoginAccountTool()
        self.tableData = accountTool.accounts
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return LoginAccountCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(LoginAccountCell.cellIdentifier(), forIndexPath: indexPath) as! LoginAccountCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.cellData = self.tableData[indexPath.row]
        cell.backgroundColor = GlobalBgColor
        return cell
    }
    
    private func wxLogin(account:AccountInfo){
        NetworkManager.sharedInstance.requestWXLogin(account.openid, unionid: account.unionid, headimgurl: account.headUrl, nickname: account.name, success: { (loginInfo:AnyObject) -> () in
            
            //成功
            let dic = loginInfo as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            LoginInfoModel.sharedInstance.setDataWithJson(objDic)
            
            //保存账号
            LoginAccountTool.saveLastLoginAccount(account)
            
            //跳转到主页
            let rootVC = ProjectManager.sharedInstance.getRootTab()
            rootVC.selectedIndex = 0
            self.navigationController?.popToRootViewControllerAnimated(false)

            }) { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
    
    private func normalLogin(account:AccountInfo){
        NetworkManager.sharedInstance.requestLogin(account.name, password: account.password, success: { (loginInfo:AnyObject) -> () in
            //成功
            let dic = loginInfo as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            LoginInfoModel.sharedInstance.setDataWithJson(objDic)
            //保存账号
            LoginAccountTool.saveLastLoginAccount(account)
            
            //跳转到主页
            let rootVC = ProjectManager.sharedInstance.getRootTab()
            rootVC.selectedIndex = 0
            self.navigationController?.popToRootViewControllerAnimated(false)
            
            NSNotificationCenter.defaultCenter().postNotificationName("ChangeLogin", object: self)
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let account = self.tableData[indexPath.row]
        NetworkManager.sharedInstance.requestLogOut({ (jsonDic:AnyObject) -> () in
            
            if account.isWXLogin == true{
                self.wxLogin(account)
            }else{
                self.normalLogin(account)
            }
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true {
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }
    @IBAction func actionLoginOut(sender: AnyObject) {
        //登出
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
    
    @IBAction func actionAddAccount(sender: AnyObject) {
        //添加账号
        let rootVC = ProjectManager.sharedInstance.getRootTab()
        let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
        loginVC.showLastLoginInfo = false
        loginVC.status = showType.add
        //更新登陆界面1202
        loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
        rootVC.presentViewController(loginVC, animated: true, completion: nil)
    }
}
