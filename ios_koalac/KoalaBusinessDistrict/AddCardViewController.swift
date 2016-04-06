//
//  AddCardViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController,UIAlertViewDelegate,UIKeyboardViewControllerDelegate {

    @IBOutlet weak var inputBankInCity: UITextField!

    @IBOutlet weak var showProvinceTextfield: UITextField!

    @IBOutlet weak var ShowbandAdressT: UITextField!
    @IBOutlet weak var showSelectCardType: UITextField!
    @IBOutlet weak var inputCardId: UITextField!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var inputAccountName: UITextField!
    @IBOutlet weak var inputBranch: UITextField!
    var cardType:[String] = [] //银行名字
    var cardTypeID:[String] = []
    var cardTypeSelect:Int = 0
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
        self.title = "添加账户"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.commitBtn.backgroundColor = GlobalStyleButtonColor
        self.commitBtn.titleLabel?.font = GGetBigCustomFont()
        
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        
        //78获取收款账户类型列表
        NetworkManager.sharedInstance.requestCardTypeList({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String,AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let type = JsonDicHelper.getJsonDicValue(item as! Dictionary<String,AnyObject>, key: "bank_type_name")
                    let typeID = JsonDicHelper.getJsonDicValue(item as! Dictionary<String,AnyObject>, key: "bank_type_id")
                    self.cardType.append(type)
                    self.cardTypeID.append(typeID)

                }
            }
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                
                }else{
                    GShowAlertMessage(error)
                }
        })
    }
    @IBAction func actionShowCardType(sender: AnyObject) {
        let cardTypePopover = PopoverSelectView.instantiateFromNib()
        let window = UIApplication.sharedApplication().keyWindow!
        cardTypePopover.show(window, title: "开户银行", data: self.cardType, defaultSelect: self.cardTypeSelect) { (selectIndex, selectString) -> () in
            self.showSelectCardType.text = selectString
            self.cardTypeSelect = selectIndex


        }
    }
    @IBAction func actionCommit(sender: AnyObject) {

         let bank_type_id = self.cardTypeID[self.cardTypeSelect] //银行
         let bank_account = self.inputCardId.text //卡号
         let bank_branch = self.inputBranch.text //银行支行
         let card_owner = self.inputAccountName.text//银行卡持有者姓名
         let province = self.showProvinceTextfield.text //开户银行所在省
         let city = self.inputBankInCity.text //开户银行所在市
         let cardType = self.showSelectCardType.text//银行名称不上传
//         let address = self.ShowbandAdressT.text//开户银行具体地址

        if cardType!.isEmpty{
            GShowAlertMessage("请选择开户银行！")
            return
        }
        if city!.isEmpty{
            GShowAlertMessage("请填写开户城市！")
            return
        }
        if province!.isEmpty{
            GShowAlertMessage("请填写开户省份！")
            return
        }
        if bank_branch!.isEmpty{
            GShowAlertMessage("请填写支行信息！")
            return
        }
        if card_owner!.isEmpty{
            GShowAlertMessage("请填写账户名称！")
            return
        }
        if bank_account!.isEmpty{
            GShowAlertMessage("请填写账号/卡号！")
            return
        }

        NetworkManager.sharedInstance.requestAddBankCard(bank_type_id, bank_account: bank_account!, bank_branch: bank_branch!, card_owner: card_owner!, province: province!, city: city!, success: { (jsonDic:AnyObject) -> () in
            let alert = UIAlertView(title: "提示", message: "添加成功！", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            }) { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{

                }else{
                    GShowAlertMessage(error)
                }
        }

    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.backAction()
        //回调闭包回传银行卡信息 life
//        for vc in (self.navigationController?.viewControllers)!
//        {
//            if vc.isKindOfClass(UndrawViewController)
//            {
//                let undrawVC = vc as! UndrawViewController
//                let index2 = self.inputCardId.text!.endIndex.advancedBy(-4)
//                let afterFour = self.inputCardId.text!.substringFromIndex(index2)
//                let strBankCard = self.showSelectCardType.text! + " 尾号\(afterFour)"
//                undrawVC.selectBankCardBlock!(strBankCard,)
//            }
//        }
    }
}
