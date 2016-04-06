//
//  FailViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/23.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class FailViewController: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var failTipLabel: UILabel!
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
        self.failTipLabel.font = GGetNormalCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
    }
    @IBAction func actionOk(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
