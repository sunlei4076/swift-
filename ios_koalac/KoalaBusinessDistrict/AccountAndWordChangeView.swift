//
//  AccountAndWordChangeView.swift
//  
//
//  Created by seekey on 15/10/16.
//
//

import UIKit

class AccountAndWordChangeView: UIView,UIKeyboardViewControllerDelegate {

    private var setType:Int = 0
    @IBOutlet weak var titleLabel: UILabel!
    //首次设置账号密码
    @IBOutlet weak var setAccountView: UIView!
    @IBOutlet weak var setAccountInputNameTextField: UITextField!
    @IBOutlet weak var setAccountInputPasswordTextField: UITextField!
    @IBOutlet weak var setAccountInputConfirmPasswordTextField: UITextField!
    //修改密码
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var showAccountLabel: UILabel!
    @IBOutlet weak var changPasswordInputPasswordTextField: UITextField!
    @IBOutlet weak var changPasswordInputNewPasswordTextField: UITextField!
    @IBOutlet weak var changePasswordInputConfirmPasswordTextField: UITextField!
    class func instantiateFromNib() -> AccountAndWordChangeView {
        let nibs = UINib(nibName: "AccountAndWordChangeView", bundle: nil).instantiateWithOwner(nil, options: nil)
        return nibs.first as! AccountAndWordChangeView
    }

    private func initData(){
        //TODO 显示账号
        if self.setType == 2{
            self.showAccountLabel.text = LoginInfoModel.sharedInstance.user_name
        }
    }
    
    //type, 1:绑定账号密码  2:修改密码
    func show(type: Int){
        let window = UIApplication.sharedApplication().keyWindow
        self.frame = UIScreen.mainScreen().bounds
        window?.addSubview(self)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.keyboard.boardDelegate = self
        
        self.setType = type
        if self.setType == 1{
            self.setAccountView.hidden = false
            self.changePasswordView.hidden = true
            self.titleLabel.text = "设置账号密码"
        }else{
            self.setAccountView.hidden = true
            self.changePasswordView.hidden = false
            self.titleLabel.text = "更改密码"
            self.showAccountLabel.text = LoginInfoModel.sharedInstance.user_name
        }
        self.initData()
    }
    
    func hide(){
        self.removeFromSuperview()
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.keyboard.boardDelegate = nil
    }
    
    //MARK: - IBActions
    @IBAction func okAction(sender: AnyObject) {
        if self.setType == 1{
            //绑定账号
            let inputName = self.setAccountInputNameTextField.text
            let inputPassword = self.setAccountInputPasswordTextField.text
            let inputConfirmPassword = self.setAccountInputConfirmPasswordTextField.text
            if inputName?.characters.count == 0{
                GShowAlertMessage("账号名不能为空！")
                return
            }
            if inputPassword?.characters.count < 6{
                GShowAlertMessage("请输入至少6位密码！")
                return
            }
            
            if inputPassword != inputConfirmPassword{
                GShowAlertMessage("两次输入的密码不一致，请重新修改！")
                return
            }
            
            //网络请求
            NetworkManager.sharedInstance.requestBindAccount(inputName!, password: inputPassword!, success: { (jsonDic:AnyObject) -> () in
                self.hide()
                GShowAlertMessage("提交成功，可用设置的新账号登录啦！")
                LoginInfoModel.sharedInstance.store.binded_user = "1"
                LoginInfoModel.sharedInstance.user_name = inputName!
                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                    
                    }else{
                        GShowAlertMessage(error)
                    }
            })
            
        }else{
            //修改密码
            let inputOldPassword = self.changPasswordInputPasswordTextField.text
            let inputPassword = self.changPasswordInputNewPasswordTextField.text
            let inputConfirmPassword = self.changePasswordInputConfirmPasswordTextField.text
            
            if inputOldPassword?.characters.count == 0{
                GShowAlertMessage("请输入旧密码！")
                return
            }
            
            if inputPassword?.characters.count < 6{
                GShowAlertMessage("请输入至少6位密码！")
                return
            }
            if inputPassword != inputConfirmPassword{
                GShowAlertMessage("两次输入的密码不一致，请重新修改！")
                return
            }
            //网络请求
            NetworkManager.sharedInstance.requestChangePassword(inputOldPassword!, newPassword: inputPassword!, success: { (jsonDic:AnyObject) -> () in
                self.hide()
                GShowAlertMessage("密码修改成功！")
                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                        
                    }else{
                        GShowAlertMessage(error)
                    }
            })
        }
    }
    @IBAction func cancelAction(sender: AnyObject) {
        self.hide()
    }
    
    //MARK : - UIKeyboardViewControllerDelegate
    func alttextField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if textField != setAccountInputNameTextField{
            let maxLength = 16
            let input:NSString = textField.text! as NSString
            let new = input.stringByReplacingCharactersInRange(range, withString: string)
            
            if maxLength-new.characters.count > 0{
                return true
            }else{
                GShowAlertMessage("所输入的密码不能超过16位！")
                return false
            }
        }
        
        return true
    }
    
   
}
