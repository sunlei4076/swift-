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
    var advistEntry:String = ""
    var activityIndicatorView:UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
//        GShowAlertMessage("关闭推送测试1.1.1")
        self.initControl()
        self.initData()
        //添加菊花圈
//        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
//        37.
//            activityIndicatorView.frame = CGRectMake(self.view.frame.size.width/2 - 50, 250, 100, 100)
//        38.
//            activityIndicatorView.hidesWhenStopped = true
//        39.
//            activityIndicatorView.color = UIColor.blackColor()
          activityIndicatorView = UIActivityIndicatorView.init(frame: CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2-100, 80, 80))
        activityIndicatorView!.backgroundColor = UIColor.blackColor()
        activityIndicatorView?.alpha = 0.7
        activityIndicatorView!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicatorView?.layer.cornerRadius = 5
        activityIndicatorView?.layer.masksToBounds = true
        activityIndicatorView!.hidesWhenStopped = true
        self.view.addSubview(activityIndicatorView!)
        
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
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
//        self.navigationItem.leftBarButtonItem = backItem
        
        //closeBtn
        let closeBtn:UIButton = UIButton(type:UIButtonType.Custom)
        closeBtn.setTitle("关闭", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = GGetNormalCustomFont()
        closeBtn.frame = CGRectMake(95, 0, 45, 30)
        closeBtn.addTarget(self, action: Selector("pressClose"), forControlEvents: UIControlEvents.TouchUpInside)
        let colseItem = UIBarButtonItem(customView: closeBtn)
        self.navigationItem.leftBarButtonItems = [backItem,colseItem]
        
//        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
////        rightBtn.setImage(UIImage(named: "NavigationClose"), forState: UIControlState.Normal)
//        rightBtn.frame = CGRectMake(0, 0, 30, 30)
//        rightBtn.addTarget(self, action: Selector("pressClose"), forControlEvents: UIControlEvents.TouchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        self.view.backgroundColor = GlobalBgColor
        
        self.webView.delegate = self
        self.view.addSubview(self.webView)
    }
    
    func pressClose(){
        self.navigationController?.popViewControllerAnimated(true)
//        GShowAlertMessage("helloworld")
        if self.advistEntry == "广告"
        {
            if levelModelInfoBlock != nil
            {
                levelModelInfoBlock!()
            }else{
                 ProjectManager.sharedInstance.versionCheck()
            }


        }
    }
    
    func backAction(){
        if self.webView.canGoBack == true{
            self.webView.goBack()
        }else{
            self.navigationController?.popViewControllerAnimated(true)
//            GShowAlertMessage("nimei")
            if self.advistEntry == "广告"
            {
                if levelModelInfoBlock != nil
                {
                    levelModelInfoBlock!()
                }else{
                     ProjectManager.sharedInstance.versionCheck()
                }
                           }
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
//webview代理
    func webViewDidStartLoad(webView: UIWebView) {
//        self.activityIndicatorView?.hidden = false
        self.activityIndicatorView?.startAnimating()
    }
    func webViewDidFinishLoad(webView: UIWebView) {

        self.activityIndicatorView?.stopAnimating()
//        self.activityIndicatorView?.hidden = true
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {

//        self.activityIndicatorView?.hidden = true
        self.activityIndicatorView?.stopAnimating()
    }



}
