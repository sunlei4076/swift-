//
//  SuccessViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/23.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cardTipLabel: UILabel!
    @IBOutlet weak var moneyTipLabel: UILabel!
    @IBOutlet weak var showMoneyLabel: UILabel!
    @IBOutlet weak var showCardTypeLabel: UILabel!
    @IBOutlet weak var successDateLabel: UILabel!
    @IBOutlet weak var successTipLabel: UILabel!
    
    var cardMessage:String = ""
    var moneyNum:String = ""
    
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
        self.title = "提现详情"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.okBtn.backgroundColor = GlobalStyleButtonColor
        self.okBtn.titleLabel?.font = GGetBigCustomFont()
        
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
        self.successDateLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.successDateLabel.textColor = UIColor.lightGrayColor()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        self.showCardTypeLabel.text = self.cardMessage
        self.showMoneyLabel.text = "￥" + self.moneyNum
        self.successDateLabel.hidden = true
    }

    @IBAction func actionOk(sender: AnyObject) {
        let vcArray = self.navigationController?.viewControllers
        if vcArray != nil{
            for item in vcArray!{
                if item .isKindOfClass(ShowAccountCashViewController){
                    let toVC = item 
                    self.navigationController?.popToViewController(toVC, animated: true)
                }
            }
        }
    }
}
