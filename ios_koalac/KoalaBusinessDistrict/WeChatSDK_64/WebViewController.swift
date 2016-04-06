//
//  WebViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/11.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    private let webView:UIWebView = UIWebView()
    var webUrl:String?
    var webRequest:NSURLRequest?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControl()
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
    }
    
    private func initControl(){
        //back
        var backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        let rightBtn:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        rightBtn.setImage(UIImage(named: "NavigationClose"), forState: UIControlState.Normal)
        rightBtn.frame = CGRectMake(0, 0, 30, 30)
        rightBtn.addTarget(self, action: Selector("pressClose"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("pressClose"))
        
        self.view.backgroundColor = GlobalBgColor
        
        self.webView.delegate = self
        self.view.addSubview(self.webView)
    }
    
    func pressClose(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func backAction(){
        if self.webView.canGoBack == true{
            self.webView.goBack()
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func initData(){
        if let request = self.webRequest{
            self.webView.loadRequest(request)
        }else{
            if let url = self.webUrl {
                self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            }
        }
    }

}
