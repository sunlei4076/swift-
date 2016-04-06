//
//  RegisterPasswordViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/9.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

//protocol RegisteriPhoneNumbDelegate: NSObjectProtocol {
//    func registeriPhoneNumb(number: NSString)
//}

class RegisteriPhoneIdentifyController: UIViewController, UIKeyboardViewControllerDelegate {
    
//    weak var iPhoneNumbDelegate: RegisteriPhoneNumbDelegate?

    @IBOutlet weak var iPhoneNum: UITextField!
    @IBOutlet weak var identifyNum: UITextField!
    @IBOutlet weak var getIdentifyNum: UIButton!
    @IBOutlet weak var agreedProtocolBtn: UIButton!

//    var registerAccount:RegisterModel = RegisterModel()
    
    
    private var timer: NSTimer!
    private var countDown = 0
    private var originCoutDown: Int!
    //回调接口
    var restartCallback: (() -> (Void))?
    //动态计数时，加在数字前面的字符串
    var countFrontString: String = ""
    //动态计数时，加在数字后面的字符串
    var countRearString: String = "秒后可重发"
    
//    //标识不同地方调用：1，提现密码设置 2，注册密码设置
//    var showType:Int = 0
//    var registerAccount:RegisterModel = RegisterModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
        self.iPhoneNum.keyboardType = UIKeyboardType.NumberPad
        self.identifyNum.keyboardType = UIKeyboardType.NumberPad
        
        
//        self.initData()
    }

    struct RegexHelper {
        let regex: NSRegularExpression?
        
        init(_ pattern: String) {
            do{
                regex = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            }catch{
                regex = nil
            }
        }
        
        func match(input: String) -> Bool {
        
            if let matches = regex?.matchesInString(input, options: .ReportCompletion, range: NSMakeRange(0, input.characters.count)) {
                    return matches.count > 0
            } else {
                return false
            }
        }
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
        self.title = "开店认证"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        //next；
        let nextBtn = GNavigationNext()
        nextBtn.addTarget(self, action: Selector("nextAction"), forControlEvents: UIControlEvents.TouchUpInside)
        //设置字体
        nextBtn.titleLabel?.font = GGetBigCustomFont()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextBtn)
        
        self.view.backgroundColor = GlobalBgColor;

    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //下一步；
    func nextAction(){
        if(self.iPhoneNum.text?.characters.count != 11){
            GShowAlertMessage("请输入正确的手机号！")
            return
        }
        if(self.getIdentifyNum.titleLabel?.text == "获取验证码"){
            GShowAlertMessage("请点击获取验证码！")
            return
        }
        
        if(self.identifyNum.text?.characters.count < 1 ){
            GShowAlertMessage("请输入验证码！")
            return
        }
        
        if(self.agreedProtocolBtn.selected){
            GShowAlertMessage("请同意开店协议！")
            return
        }
        
        //收起键盘
        self.editing = false
        
        NetworkManager.sharedInstance.requestCheckSecurityCode(self.iPhoneNum.text!, securityCode: self.identifyNum.text!, success: { (AnyObject) -> () in
            
            let register = RegisterInfoViewController(nibName:"RegisterInfoViewController", bundle:nil)
            register.registerAccount.tel = self.iPhoneNum.text!
            pprLog(register.registerAccount.tel)
            register.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(register, animated: true)
            
        }) { (String, Bool) -> () in
            GShowAlertMessage("验证码不正确！")
        }

    }
    
//    func registeriPhoneNumb(number : NSString) {
//    }
    
//    private func initData(){
//        //do nothing
//    }
    
    //已阅读协议点击；
    @IBAction func agreedProtocol(sender: UIButton) {
        self.agreedProtocolBtn.selected = !self.agreedProtocolBtn.selected
    }
    
    //协议点击；
    @IBAction func webToKoalacProtocol(sender: AnyObject) {
        let webVC = WebViewController()
        webVC.title = "服务条款"
        webVC.webUrl = "http://shop.lifeq.com.cn/releasenote/protocol.html"
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
    //获取验证码点击；
    @IBAction func getIdentifyNum(sender: AnyObject) {
        //判断手机号开头和位数；
        let phoneNumPattern = "^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$"
        let phoneNum = RegexHelper(phoneNumPattern)
        let maybePhone = self.iPhoneNum.text
        
        if phoneNum.match(maybePhone!) {
            
            self.iPhoneNum.enabled = false
            
            
            //发送手机号；
            NetworkManager.sharedInstance.requestGetSecurityCode(maybePhone!, success: { (AnyObject) -> () in
                GShowAlertMessage("请注意接听电话，获取语音验证码！")
                self.iPhoneNum.textColor = UIColor.lightGrayColor()
                
                self.originCoutDown = 60
                self.countDown = 60
                self.restartCallback = {() -> (Void) in
                    self.getIdentifyNum .setTitle("重新获取验证码", forState: UIControlState.Normal)
                }
                self.restart()
                
            }, fail: { (error:String, needRelogin:Bool) -> () in
                pprLog("112")
                self.iPhoneNum.enabled = true
//                GShowAlertMessage("请重新获取验证码！")
                GShowAlertMessage(error)
                
            })
        }
        else{
            GShowAlertMessage("请输入正确的手机号！")
        }
    }
    
    //开始倒计时
    func restart() {
//        pprLog(message: "\(self.countDown)")
        self.countDown = self.originCoutDown
//        pprLog(message: "\(self.countDown)")
        self.heartbeat()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "heartbeat", userInfo: nil, repeats: true)
        self.getIdentifyNum.enabled = false
        self.restartCallback?()
    }
    
    @objc private func heartbeat() {
//        pprLog(message: "\(self.countDown)")
        self.countDown--
        if self.countDown == 0 {
            self.normalState()
            return
        }
        let countDwonStr = self.countFrontString + String(self.countDown) + self.countRearString
        self.getIdentifyNum.setTitle(countDwonStr, forState: UIControlState.Disabled)
    }
    
    private func normalState() {
        if self.timer == nil {
            return
        }
        self.timer.invalidate()
        self.timer = nil
        self.getIdentifyNum.enabled = true
    }
}

