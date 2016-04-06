//
//  SendQuestionViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class SendQuestionViewController: UIViewController,UITextViewDelegate,UIAlertViewDelegate{

    @IBOutlet weak var placeHoldLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var commitBtn: UIButton!
    
    var showType:Int = 0 //1:今日备注 2:问题反馈
    var remarkRequestDate:NSDate = NSDate()
    
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
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.placeHoldLabel.textColor = UIColor.lightGrayColor()
        self.inputTextView.delegate = self
        self.commitBtn.backgroundColor = GlobalStyleButtonColor
        
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
        self.commitBtn.titleLabel?.font = GGetBigCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func requestRemarkMessage(){
        NetworkManager.sharedInstance.requestGetRemark(self.remarkRequestDate, success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            let message = JsonDicHelper.getJsonDicValue(objDic, key: "notes")
            if message.isEmpty == false{
                self.inputTextView.text = message
                self.placeHoldLabel.hidden = true
            }
            }) { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
    
    private func initData(){
        switch self.showType{
        case 1:
            self.title = "今日备注"
            self.placeHoldLabel.text = "输入您的备注"
            self.inputTextView.text = ""
            self.commitBtn.setTitle("保存", forState: UIControlState.Normal)
            self.requestRemarkMessage()
            break;
        case 2:
            self.title = "联系我们"
            self.placeHoldLabel.text = "描述一下出现的问题"
            self.inputTextView.text = ""
            self.commitBtn.setTitle("提交", forState: UIControlState.Normal)
        default:
            return
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.placeHoldLabel.hidden = true
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.characters.count == 0 {
            self.placeHoldLabel.hidden = false
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let new = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString:text)
        if new.characters.count == 0{
            self.placeHoldLabel.hidden = false
        }else{
            self.placeHoldLabel.hidden = true
        }
        return true
    }
    @IBAction func actionCommit(sender: AnyObject) {
        //提交
        switch self.showType{
        case 1:
            //今日备注
            let inputStr = self.inputTextView.text
            if inputStr.isEmpty{
                GShowAlertMessage("请输入您的备注！")
                return
            }
            
            NetworkManager.sharedInstance.requestSetMark(self.remarkRequestDate, content: inputStr, success: { (jsonDic:AnyObject) -> () in
                let alertView = UIAlertView(title: "提示", message: "保存成功", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                    
                    }else{
                        GShowAlertMessage(error)
                    }
            })
        case 2:
            //问题反馈
            let question = self.inputTextView.text
            if question.isEmpty{
                GShowAlertMessage("请输入所遇到的问题详细！")
                return
            }
            
            NetworkManager.sharedInstance.requestSendQuestion(question, success: { (jsonDic:AnyObject) -> () in
                let alertView = UIAlertView(title: "提示", message: "提交成功,谢谢您的反馈", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                }) { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                        
                    }else{
                        GShowAlertMessage(error)
                    }
            }
        default:
            return
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.backAction()
    }
}
