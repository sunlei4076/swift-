
//
//  ShowAccountCashViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ShowAccountCashViewController: UIViewController {

    var accountDrawal:AccountDrawalModel = AccountDrawalModel()

    @IBOutlet weak var showDrawalMoneyLabel: UILabel!
    @IBOutlet weak var showUndrawalMoneyLabel: UILabel!
    //提现中 life
    @IBOutlet weak var showDrawalingMoneyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initControl(){
        self.title = "商家提现"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.showDrawalMoneyLabel.text = ""
        self.showUndrawalMoneyLabel.text = ""
        self.showDrawalingMoneyLabel.text = ""
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
        self.showDrawalMoneyLabel.font = GGetCustomFontWithSize(GBigFontSize+2.0)
        self.showUndrawalMoneyLabel.font = GGetCustomFontWithSize(GBigFontSize+4.0)
        self.showDrawalingMoneyLabel.font = GGetCustomFontWithSize(GBigFontSize+4.0)
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        NetworkManager.sharedInstance.requestAccountDrawalInfo({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String,AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            self.accountDrawal = AccountDrawalModel(jsonDic: objDic)
            self.showDrawalMoneyLabel.text = "￥"+self.accountDrawal.drawaled
            self.showDrawalingMoneyLabel.text = "￥"+self.accountDrawal.freeze
            self.showUndrawalMoneyLabel.text = "￥"+self.accountDrawal.balance
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                    self.showUndrawalMoneyLabel.text = "￥0.00"
                    self.showDrawalMoneyLabel.text = "￥0.00"
                    self.showDrawalingMoneyLabel.text = "￥0.00"
                }
        })
    }


    @IBAction func actionUndrawal(sender: AnyObject) {
        let undrawalVC = UndrawViewController(nibName:"UndrawViewController", bundle:nil)
        undrawalVC.accountDrawal = self.accountDrawal
        //====life
        let hasSetPwd = LoginInfoModel.sharedInstance.had_drawalpwd
        if (hasSetPwd as NSString).floatValue == 0.0{
            //没有设置提现密码
            let setPasswordVC = RegisterPasswordViewController(nibName:"RegisterPasswordViewController", bundle:nil)
            setPasswordVC.showType = 1 //1设置密码，2进入未提现页面
            setPasswordVC.accountDrawal = self.accountDrawal
            self.navigationController?.pushViewController(setPasswordVC, animated: true)

        }else{
            //已经设置密码就跳到未提现金额页面
            self.navigationController?.pushViewController(undrawalVC, animated: true)
        }

    }
    //已提现按钮
    @IBAction func actionDrawal(sender: AnyObject) {
        let drawalVC = DrawalViewController(nibName:"DrawalViewController", bundle:nil)
        drawalVC.moneyNum = "￥"+self.accountDrawal.drawaled
        drawalVC.drawalType = "2" //2表示已提现
        self.navigationController?.pushViewController(drawalVC, animated: true)
    }
    //账户管理按钮
    @IBAction func actionManagerBankCards(sender: AnyObject) {
        let cardManagerVC = CardManagerViewController(nibName:"CardManagerViewController", bundle:nil)
        self.navigationController?.pushViewController(cardManagerVC, animated: true)
    }
//提现中按钮
    @IBAction func actionDrawaling(sender: AnyObject) {

        let drawalingVC = DrawalViewController(nibName:"DrawalViewController", bundle:nil)
        drawalingVC.drawalType = "1"
        drawalingVC.moneyNunDrawaling = "￥"+self.accountDrawal.freeze
        self.navigationController?.pushViewController(drawalingVC, animated: true)

        
    }

}
