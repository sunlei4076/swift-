//
//  UndrawViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class UndrawViewController: UIViewController, UIAlertViewDelegate, UIKeyboardViewControllerDelegate{
    var callBackFlag:Int = 0
    var accountDrawal:AccountDrawalModel = AccountDrawalModel()
    var bankCardList:[BankCardInfoNewModel] = []
    var cardSelectIndex:Int = 0
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var inputDrawalNumTextField: UITextField!
    @IBOutlet weak var showSelectBankCardLabel: UILabel!
    
    @IBOutlet weak var showPasswordField: UITextField! //提现密码
    @IBOutlet weak var showMoneyNumLabel: UILabel!
    //回调显示银行卡
//    var selectBankCardBlock:((String,BankCardInfoNewModel)->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
//        self.initData()
//        self.selectBankCardBlock =
//            {
//                (str : String, BankCardInfo:BankCardInfoNewModel) -> () in
//                self.showSelectBankCardLabel.text = str
//                self.bankCardList.append(BankCardInfo)
//
//
//        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         self.initData()
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
        // Dispose of any resources that can be recreated.
    }
    

    private func initControl(){
        self.title = "未提现金额"
        //提现密码设置为黑点
        self.showPasswordField.secureTextEntry = true
        self.showPasswordField.keyboardType = UIKeyboardType.Default
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.okBtn.backgroundColor = GlobalStyleButtonColor
        self.showSelectBankCardLabel.textColor = UIColor.darkGrayColor()
        self.inputDrawalNumTextField.textColor = UIColor.darkGrayColor()
        self.tipLabel.textColor = UIColor.lightGrayColor()
        
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
        self.showMoneyNumLabel.font = GGetCustomFontWithSize(GBigFontSize+4.0)
        self.okBtn.titleLabel?.font = GGetBigCustomFont()
        self.tipLabel.font = GGetCustomFontWithSize(GNormalFontSize-1.0)
    }
    
    func backAction(){
        if self.callBackFlag == 1{ //==1表示从设置密码页面进入未提现页面
            for vc in (self.navigationController?.viewControllers)!
            {
                if vc.isKindOfClass(ShowAccountCashViewController)
                {
                    let ShowAccountCash = vc as! ShowAccountCashViewController

                    self.navigationController?.popToViewController(ShowAccountCash, animated: true)
                }
            }

        }else{
             self.navigationController?.popViewControllerAnimated(true)
        }

        
    }
    
    private func initData(){
        self.showMoneyNumLabel.text = "￥"+self.accountDrawal.balance
        self.tipLabel.text = "说明：提现上限为:\(self.accountDrawal.drawal_max) 提现下限为:500"
        
        //获取银行账户列表
        NetworkManager.sharedInstance.requestDrawalCardList({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let card = BankCardInfoNewModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.bankCardList.append(card)
                }
            }
            
            if self.bankCardList.count > 0{
                self.cardSelectIndex = 0
                let card = self.bankCardList.first
                
                self.showSelectBankCardLabel.text = self.getToShowCardInfo(card!)
            }else{
                GShowAlertMessage("无账户信息！")
            }
            
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }

    private func getToShowCardInfo(card:BankCardInfoNewModel) -> String{
        let rtn:String
        let cardNumber = card.bank_account
        let cardNumberLength = card.bank_account.characters.count
        if cardNumberLength < 8{
            rtn = card.bank_type_name + " 账号：\(cardNumber)"
            
        }else{
            let index = cardNumber.startIndex.advancedBy(4)
            let index2 = cardNumber.endIndex.advancedBy(-4)
            let firstFour = cardNumber.substringToIndex(index)
            let afterFour = cardNumber.substringFromIndex(index2)
            rtn = card.bank_type_name + " 账号：\(firstFour)***\(afterFour)"
        }
        return rtn
    }
    //选择账号
    @IBAction func actionChangeCard(sender: AnyObject) {

        var tempArray:[String] = []
        for item in self.bankCardList{
            let cardStr = self.getToShowCardInfo(item)
            tempArray.append(cardStr)
        }
        //数组为空跳到添加银行卡
        if tempArray.count == 0 {
            pprLog("跳到添加银行卡页面")
            let addCardVC = AddCardViewController(nibName:"AddCardViewController", bundle:nil)
            self.navigationController?.pushViewController(addCardVC, animated: true)



        }else{
            let cardPopover = PopoverSelectView.instantiateFromNib()
            let window = UIApplication.sharedApplication().keyWindow
            cardPopover.show(window!, title: "选择类型", data: tempArray, defaultSelect: self.cardSelectIndex) { (selectIndex, selectString) -> () in
                self.showSelectBankCardLabel.text = selectString
                self.cardSelectIndex = selectIndex

        }
        }
    }
    //提交按钮
    @IBAction func actionCommit(sender: AnyObject) {
         let drawalBankCard = self.showSelectBankCardLabel.text
        if drawalBankCard!.isEmpty{
            GShowAlertMessage("请选择账户！")
            return
        }
        self.inputDrawalNumTextField.resignFirstResponder()
        let drawalNum = self.inputDrawalNumTextField.text
        if drawalNum!.isEmpty{
            GShowAlertMessage("请输入提现金额！")
            return
        }
        self.showPasswordField.resignFirstResponder()
        let drawalPass = self.showPasswordField.text
        if drawalPass!.isEmpty{
            GShowAlertMessage("请输入提现密码！")
            return
        }
        
        let drawalNumFloat = (drawalNum! as NSString).floatValue
        let max = (self.accountDrawal.drawal_max as NSString).floatValue
        let min = (self.accountDrawal.drawal_min as NSString).floatValue
        
        if drawalNumFloat > max{
            GShowAlertMessage("提现金额不能大于提现上限！")
            return
        }
        
        if drawalNumFloat < min{
            GShowAlertMessage("提现金额不能少于提现下限！")
            return
        }
        //需要加个密码判断life
        //发网络请求
         self.requestWithDrawal()

        
//        let hasSetPwd = LoginInfoModel.sharedInstance.had_drawalpwd
        //0 进入未提现页面 1进入设置密码页面
//        if (hasSetPwd as NSString).floatValue == 0.0{
//            //没有设置提现密码
//            let setPasswordVC = RegisterPasswordViewController(nibName:"RegisterPasswordViewController", bundle:nil)
//            setPasswordVC.showType = 1
//            self.navigationController?.pushViewController(setPasswordVC, animated: true)
//            
//        }else{
//            let passwordInput = UIAlertView()
//            passwordInput.title = "请输入提现密码"
//            passwordInput.addButtonWithTitle("确定")
//            passwordInput.addButtonWithTitle("取消");
//            passwordInput.delegate = self
//            
//            passwordInput.alertViewStyle = UIAlertViewStyle.SecureTextInput
//            passwordInput.show()
//        }
    }

    //验证密码这部去掉V2.8
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        let butStr = alertView.buttonTitleAtIndex(buttonIndex)
//        if butStr == "确定"{
//                let password = alertView.textFieldAtIndex(0)!.text
//            if password!.isEmpty{
//                GShowAlertMessage("请输入提现密码！")
//                return
//            }
//            alertView.textFieldAtIndex(0)?.resignFirstResponder()
//            NetworkManager.sharedInstance.requestCheckDrawalPwd(password!, success: { (jsonDic:AnyObject) -> () in
//                //密码正确
//                self.requestWithDrawal()
//                }, fail: { (error:String, needRelogin:Bool) -> () in
//                    if needRelogin == true{
//                    
//                    }else{
//                        //密码错误
//                        GShowAlertMessage(error)
//                    }
//            })
//        }else{
//        
//        }
//    }

    func requestWithDrawal(){
        let money = self.inputDrawalNumTextField.text
        let selectCard = self.bankCardList[self.cardSelectIndex]
        let drawalpwd = self.showPasswordField.text
        NetworkManager.sharedInstance.requestDrawalDo(money!,drawalpwd:drawalpwd!,cardInfo:selectCard, success: { (jsonDic:AnyObject) -> () in

            //提现成功  【不需要跳转这个控制器v2.8】
//            let successVC = SuccessViewController(nibName:"SuccessViewController", bundle:nil)
//            successVC.cardMessage = self.showSelectBankCardLabel.text!
//            successVC.moneyNum = self.inputDrawalNumTextField.text!
//            
//
//            self.navigationController?.pushViewController(successVC, animated: true)
            //V2.8 成功跳到商家提现页面并更新 life
            for vc in (self.navigationController?.viewControllers)!
            {
                if vc.isKindOfClass(ShowAccountCashViewController)
                {
                    let ShowAccountCash = vc as! ShowAccountCashViewController

                    self.navigationController?.popToViewController(ShowAccountCash, animated: true)
                }
            }
        }) { (error:String, needRelogin:Bool) -> () in
            if needRelogin == true{
            
            }else{
                //提现失败
                GShowAlertMessage(error)
//                let failVC = FailViewController(nibName:"FailViewController", bundle:nil)
//                self.navigationController?.pushViewController(failVC, animated: true)
            }
        }
    }
}
