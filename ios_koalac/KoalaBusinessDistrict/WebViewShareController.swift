//
//  WebViewShareController.swift
//  koalac_PPM
//
//  Created by seekey on 15/11/17.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class WebViewShareController: UIViewController,UIWebViewDelegate {

    private let webView:UIWebView = UIWebView()
    var webShareUrl:String?
    var webShareRequest:NSURLRequest?
    var webShareType:String?
    var activityIndicatorView:UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControl()
        self.initData()
        activityIndicatorView = UIActivityIndicatorView.init(frame: CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2-100, 80, 80))
        activityIndicatorView!.backgroundColor = UIColor.blackColor()
        activityIndicatorView?.alpha = 0.7
        activityIndicatorView!.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicatorView?.layer.cornerRadius = 5
        activityIndicatorView?.layer.masksToBounds = true
        //        activityIndicatorView.hidesWhenStopped = true
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
    
    private func initData(){
        if let request = self.webShareRequest{
            self.webView.loadRequest(request)
        }else{
            if let url = self.webShareUrl {
                self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            }
        }
    }
    
    private func initControl(){
        //backBtn
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        //closeBtn
        let closeBtn:UIButton = UIButton(type:UIButtonType.Custom)
//        closeBtn.setImage(UIImage(named: "NavigationClose"), forState: UIControlState.Normal)
        closeBtn.setTitle("关闭", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = GGetNormalCustomFont()
        closeBtn.frame = CGRectMake(95, 0, 45, 30)
        closeBtn.addTarget(self, action: Selector("pressClose"), forControlEvents: UIControlEvents.TouchUpInside)
        let colseItem = UIBarButtonItem(customView: closeBtn)
        self.navigationItem.leftBarButtonItems = [backItem,colseItem]
        
        pprLog(self.title)
        
        if (self.webShareType == "face_payment") || (self.webShareType == "task_list")  {

        }else{
            //shareBtn
            let shareBtn:UIButton = UIButton(type:UIButtonType.Custom)
            shareBtn.setTitle("分享", forState: UIControlState.Normal)
            shareBtn.titleLabel?.font = GGetNormalCustomFont()
            shareBtn.frame = CGRectMake(0, 0, 45, 30)
            shareBtn.addTarget(self, action: Selector("shareAction"), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareBtn)
        }

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
    
    func shareAction(){
        let actingShareView = ActingShareView.instantiateFromNib()
        actingShareView.shareWebType = self.webShareType!
//        actingShareView.shareWebURL = webShareUrl!
        actingShareView.shareTitle = self.title!
        if actingShareView.shareTitle.hasPrefix("生意经，用数据说话")
        {//拼接了store_id才可以在微信打开链接life
            actingShareView.shareWebURL = webShareUrl!+"&store_id="+LoginInfoModel.sharedInstance.store.store_id
        }else{
            actingShareView.shareWebURL = webShareUrl!
            
            pprLog(actingShareView.shareWebURL)
            
        }
        pprLog(webShareUrl)
        pprLog(self.title) 
        actingShareView.actingShareViewShow()
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
