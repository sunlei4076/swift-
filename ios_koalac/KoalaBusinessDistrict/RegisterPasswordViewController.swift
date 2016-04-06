//
//  RegisterPasswordViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/9.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class RegisterPasswordViewController: UIViewController, UIKeyboardViewControllerDelegate {

    @IBOutlet weak var inputPasswordTwo: UITextField!
    @IBOutlet weak var inputPasswordOne: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    var accountDrawal:AccountDrawalModel = AccountDrawalModel()
    //标识不同地方调用：1，提现密码设置 2，注册密码设置
    var showType:Int = 0
    var registerAccount:RegisterModel = RegisterModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControl()
        self.initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    private func initControl(){
        switch self.showType{
        case 1:
            self.title = "密码设置"
            self.inputPasswordOne.placeholder = "提现密码"
            self.inputPasswordTwo.placeholder = "确认提现密码"
        case 2:
            self.title = "注册账号"
        default:
            break
        }
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor;
        self.nextBtn.backgroundColor = GlobalStyleButtonColor;
        
        //设置字体
        self.nextBtn.titleLabel?.font = GGetBigCustomFont()
        self.inputPasswordOne.font = GGetNormalCustomFont()
        self.inputPasswordTwo.font = GGetNormalCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        //do nothing
    }
    
    @IBAction func nextAction(sender: AnyObject) {
        //非空判断
        let passwordOne = self.inputPasswordOne.text;
        let passwordTwo = self.inputPasswordTwo.text;
        if(passwordOne!.isEmpty){
            GShowAlertMessage("请输入密码！")
            return
        }
        if(passwordTwo!.isEmpty){
            GShowAlertMessage("请确认密码！")
            return
        }
        if passwordOne?.characters.count < 6{
            GShowAlertMessage("密码不能小于6位数！")
            return
        }
        if passwordOne != passwordTwo{
            GShowAlertMessage("两次密码不相同！")
            return
        }
        //收起键盘
        self.editing = false
        switch self.showType{
        case 1:
            //提现密码设置
            NetworkManager.sharedInstance.requestDrawalPasswordSet(passwordOne!, repeatPassword: passwordTwo!, success: { (jsonDic:AnyObject) -> () in
                    LoginInfoModel.sharedInstance.had_drawalpwd = "1";
//                    self.navigationController?.popViewControllerAnimated(true)
                //==
                let undrawalVC = UndrawViewController(nibName:"UndrawViewController", bundle:nil)
                //传数据模型
                undrawalVC.accountDrawal = self.accountDrawal
                undrawalVC.callBackFlag = 1

                self.navigationController?.pushViewController(undrawalVC, animated: true)
                //==

                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                    
                    }else{
                        GShowAlertMessage(error)
                    }
            })
        case 2:
            self.registerAccount.password = passwordOne!
            //下一步
            let registerInfoVC = RegisterInfoViewController(nibName:"RegisterInfoViewController", bundle:nil)
            registerInfoVC.registerAccount = self.registerAccount
            self.navigationController?.pushViewController(registerInfoVC, animated: true)
        default:
            break
        }
        
    }
}
