//
//  AddCouponViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/3.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class AddCouponViewController: UIViewController, UIKeyboardViewControllerDelegate {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var scrollContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initControl(){
        self.title = "添加优惠券"
        
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.scrollContentView.backgroundColor = GlobalBgColor
        GSetFontInView(self.scrollContentView, font: GGetNormalCustomFont())
        
        self.nextBtn.backgroundColor = GlobalStyleButtonColor
    }

    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    
}
