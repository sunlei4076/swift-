//
//  OpenShopPopover.swift
//  koalac_PPM
//
//  Created by liuny on 15/8/14.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class OpenShopPopover: UIView {

    private var clickBlock:(()->())?
    class func instantiateFromNib() -> OpenShopPopover {
        let view = UINib(nibName: "OpenShopPopover", bundle: nil).instantiateWithOwner(nil, options: nil).first as! OpenShopPopover
        
        return view
    }

    func show(clickDone:()->()){
        let window = UIApplication.sharedApplication().keyWindow
        self.frame = UIScreen.mainScreen().bounds
        window?.addSubview(self)
        self.clickBlock = clickDone
    }
    
    class func hide(){
        let window = UIApplication.sharedApplication().keyWindow
        for view in window!.subviews{
            if view.isKindOfClass(OpenShopPopover){
                view.removeFromSuperview()
            }
        }
    }
    
    func hide(){
        self.removeFromSuperview()
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        self.hide()
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        self.hide()
        if self.clickBlock != nil{
            self.clickBlock!()
        }
    }
}
