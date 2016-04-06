//
//  WebViewInteractiveJSController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/11.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol JavaScriptSwiftDelegate: JSExport {


//    func getPrepayId(dict: [String : AnyObject]);
    func wxpay(dict: String);

}

class WebViewToJSController: UIViewController,UIWebViewDelegate, JavaScriptSwiftDelegate,UIAlertViewDelegate {

    var succeed_url:String = " "

    var webView:UIWebView = UIWebView()
    var webUrl:String?
    var webRequest:NSURLRequest?
    
    var jsContext: JSContext?
    var activityIndicatorView:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControl()
        self.initData()
         activityIndicatorView = UIActivityIndicatorView.init(frame: CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2-100, 80, 80))
        activityIndicatorView!.backgroundColor = UIColor.blackColor()
        activityIndicatorView?.alpha = 0.7
        activityIndicatorView!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicatorView?.layer.cornerRadius = 5
        activityIndicatorView?.layer.masksToBounds = true
        //        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView!.hidesWhenStopped = true
        self.view.addSubview(activityIndicatorView!)
    }
    
    private func initControl(){
        //左键
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
        
//        //右键
//        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
//        rightBtn.setImage(UIImage(named: "NavigationClose"), forState: UIControlState.Normal)
//        rightBtn.frame = CGRectMake(0, 0, 30, 30)
//        rightBtn.addTarget(self, action: Selector("pressClose"), forControlEvents: UIControlEvents.TouchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        self.view.backgroundColor = GlobalBgColor
        self.webView.scalesPageToFit = true;
        self.webView.delegate = self
        self.view.addSubview(self.webView)
    }
    
    private func initData(){
        var request:NSURLRequest?
        if (self.webRequest != nil) {
            request = self.webRequest
        }else{
            request = NSURLRequest(URL: NSURL(string: self.webUrl!)!)
        }
        
        self.webView.loadRequest(request!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
    }
    
    func wxPaySuccessJumpToUrl(webURL:String) {
        
//        let webURL:String = NetworkManager.sharedInstance.baseUrl + "/store_ws.php?ac=order_ws&status=20"

        var request:NSURLRequest?
        request = NSURLRequest(URL: NSURL(string: webURL)!)
        self.webView.loadRequest(request!)
    }
    
    func wxPayfailJumpToUrl(webURL:String) {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
        
//        let webURL:String = NetworkManager.sharedInstance.baseUrl + " /store_ws.php?ac=order_ws"

        var request:NSURLRequest?
        request = NSURLRequest(URL: NSURL(string: webURL)!)
        self.webView.loadRequest(request!)
    }
    
    
    //关闭网页
    func pressClose(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //返回上一个页面
    func backAction(){
        if self.webView.canGoBack == true{
            self.webView.goBack()
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityIndicatorView?.stopAnimating()
        self.webView.scalesPageToFit = true;
        //js调用OC的方法需要进行的一些设置
        let context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext
        self.jsContext = context
        self.jsContext?.setObject(self, forKeyedSubscript: "dispatcher")
        self.jsContext?.exceptionHandler = { (context, exception) in
            pprLog(context)
        }
    }
    

    func wxpay(dict: String) {

      let str =  self.base64EncodedStr(dict)

        let dicJson = self.dictionaryWithJsonString(str)


        //1.解码
        //2.string转字典


//        let orderName = JsonDicHelper.getJsonDicValue(dict,
//            key: "order_name")
////        pprLog(orderName)
//        let orderNumber = JsonDicHelper.getJsonDicValue(dict,
//            key: "out_trade_sn")
////        pprLog(orderNumber)
//        let pricenum = JsonDicHelper.getJsonDicValue(dict,
//            key: "pricenum")
        self.succeed_url = JsonDicHelper.getJsonDicValue(dicJson,
            key: "succeed_url")
//        pprLog(succeed_url)
        let failed_url = JsonDicHelper.getJsonDicValue(dicJson,
            key: "failed_url")
//        orderNum:String, price:String, notifyURL:String,
        WXApiTool.sharedInstance.sendPayRequest(dicJson, success: {(jsonDic:AnyObject) -> () in

            
            if self.webView.canGoBack {
                self.webView.goBack()
            }
            //支付成功
            let alert = UIAlertView(title: "提示", message: "支付成功", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            self.wxPaySuccessJumpToUrl(self.succeed_url)
//            let jsParamFunc = self.jsContext?.objectForKeyedSubscript("jsParamFunc")
            //        OC回调JS方法
//            jsParamFunc?.callWithArguments([succeed_url])

            }, fail: { (error:String, needRelogin:Bool) -> () in
                //支付失败
                GShowAlertMessage(error)
                self.wxPayfailJumpToUrl(failed_url)
        })
        
//        let jsParamFunc = self.jsContext?.objectForKeyedSubscript("jsParamFunc")
////        OC回调JS方法
//        jsParamFunc?.callWithArguments([notifyURL])
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.message == "支付成功"{
            if alertView.buttonTitleAtIndex(buttonIndex) == "确定"{
                self.wxPaySuccessJumpToUrl(self.succeed_url)
            }
        }
    }
    /*
    * @brief 把格式化的JSON格式的字符串转换成字典
    * @param jsonString JSON格式的字符串
    * @return 返回字典
    */
    func dictionaryWithJsonString(jsonString:String)->Dictionary<String,AnyObject>
    {
      let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        let dic = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options:  NSJSONReadingOptions.MutableContainers)
        pprLog(dic)
        return dic as! Dictionary<String, AnyObject>
    }

    func base64EncodedStr(base64String:String) ->String
    {
        let str1 =  base64String.stringByReplacingOccurrencesOfString("_", withString: "/")
        let str2 = str1.stringByReplacingOccurrencesOfString("-", withString: "+")

        let decodedData = NSData(base64EncodedString: str2, options:NSDataBase64DecodingOptions(rawValue: 0))
    let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)

     pprLog(decodedString)

        return decodedString! as String
    }

    //webview代理
    func webViewDidStartLoad(webView: UIWebView) {
        //        self.activityIndicatorView?.hidden = false
        self.activityIndicatorView?.startAnimating()
    }
//    func webViewDidFinishLoad(webView: UIWebView) {
//
//        self.activityIndicatorView?.stopAnimating()
//        //        self.activityIndicatorView?.hidden = true
//    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {

        //        self.activityIndicatorView?.hidden = true
        self.activityIndicatorView?.stopAnimating()
    }
}
