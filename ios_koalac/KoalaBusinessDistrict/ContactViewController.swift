//
//  ContactViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var showAddressLabel: UILabel!
    @IBOutlet weak var showPhoneLabel: UILabel!
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
        self.title = "联系我们"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
    
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
        self.showNameLabel.font = GGetBigCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){        
        self.showNameLabel.text = "广州市考拉先生网络科技有限公司"
        self.showPhoneLabel.text = "4000-588-577"

        self.showAddressLabel.text = "广州市天河区陶庄路5号五号空间5-6层"
    }
}
