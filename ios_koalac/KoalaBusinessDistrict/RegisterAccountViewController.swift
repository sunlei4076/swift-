//
//  RegisterAccountViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/9.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class RegisterAccountViewController: UIViewController, UIKeyboardViewControllerDelegate {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var inputAccount: UITextField!
    
    private var registerAccount:RegisterModel = RegisterModel()
    
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
        self.title = "注册账号"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
    
        self.view.backgroundColor = GlobalBgColor;
        self.nextBtn.backgroundColor = GlobalStyleButtonColor;
        
        //设置字体
        self.inputAccount.font = GGetNormalCustomFont()
        self.nextBtn.titleLabel?.font = GGetBigCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        //do nothing
    }
    
    @IBAction func nextAction(sender: AnyObject) {
        //非空检查
        let account = self.inputAccount.text
        if(account!.isEmpty){
            GShowAlertMessage("请填写注册账号！")
            return
        }
        
        //调用接口
        let networkMan = NetworkManager.sharedInstance
        networkMan.requiredAccountExist(account!, success: { (jsonDic:AnyObject) -> () in
            //成功
            let json = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(json, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            let existStr = JsonDicHelper.getJsonDicValue(objDic, key:"exist")
            let errorFloat = (existStr as NSString).floatValue
            if(errorFloat == 1){
                //用户名已经存在
                GShowAlertMessage("用户名已存在!")
            }else{
                self.registerAccount.userName = account!
                self.registerAccount.real_name = account!
                //下一步
                let registerPassword = RegisterPasswordViewController(nibName:"RegisterPasswordViewController", bundle:nil)
                registerPassword.showType = 2
                registerPassword.registerAccount = self.registerAccount
                self.navigationController?.pushViewController(registerPassword, animated: true)
            }
            
            }) { (error:String, needRelogin:Bool) -> () in
                //失败
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
}
