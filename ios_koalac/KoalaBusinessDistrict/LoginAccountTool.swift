//
//  LoginAccountTool.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/1.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class AccountInfo: NSObject,NSCoding {
    var headUrl:String = ""
    var name:String = ""
    var isWXLogin:Bool = false
    
    /*******普通******** ****/
    var password:String = ""
    
    /*********微信*************/
    var openid:String = ""
    var unionid:String = ""
    
    override init(){
        super.init()
    }
    
    convenience init(loginUser:LoginInfoModel, password:String){
        self.init()
        self.headUrl = loginUser.store.store_logo
        self.name = loginUser.user_name
        self.password = password
        self.isWXLogin = false
    }
    
    convenience init(name:String, headUrl:String, openid:String, unionid:String){
        self.init()
        self.isWXLogin = true
        self.name = name
        self.headUrl = headUrl
        self.unionid = unionid
        self.openid = openid
    }
    
    required init(coder aDecoder: NSCoder) {
        self.headUrl = aDecoder.decodeObjectForKey("headUrl") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.password = aDecoder.decodeObjectForKey("password") as! String
        self.isWXLogin = aDecoder.decodeBoolForKey("iswxlogin")
        self.openid = aDecoder.decodeObjectForKey("openid") as! String
        self.unionid = aDecoder.decodeObjectForKey("unionid") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.headUrl, forKey: "headUrl")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.password, forKey: "password")
        aCoder.encodeBool(self.isWXLogin, forKey: "iswxlogin")
        aCoder.encodeObject(self.openid, forKey: "openid")
        aCoder.encodeObject(self.unionid, forKey: "unionid")
    }
}

class LoginAccountTool: NSObject {
    var accounts:[AccountInfo] = []
    //归档后的文件是加密的，所以归档文件的扩展名可以随意取
    /*使用下面的方法获取路径，在模拟器上可以使用，实机上不能使用*/
//    private let accountPath:String = NSHomeDirectory().stringByAppendingPathComponent("account.data")
    private let accountFile:String = "account1.data"
    private var accountPath:String = ""
    override init(){
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        accountPath = (documentPath as NSString).stringByAppendingPathComponent(self.accountFile)
        //反归档
        if let array = NSKeyedUnarchiver.unarchiveObjectWithFile(self.accountPath) as? [AccountInfo] {
            self.accounts = array
        }
        super.init()
    }
   
    static func getLastLoginAccount()->AccountInfo{
        if let data =  NSUserDefaults.standardUserDefaults().objectForKey("lastLogin") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! AccountInfo
        }
        return AccountInfo()
    }
    
    static func saveLastLoginAccount(account:AccountInfo){
        let data = NSKeyedArchiver.archivedDataWithRootObject(account)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "lastLogin")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func clearLastLoginAccount(){
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "lastLogin")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func saveAccount(account:AccountInfo){
        var hasSave = false
        for item in self.accounts{
            if item.isWXLogin == account.isWXLogin{
                if item.openid == account.openid {
                    hasSave = true
                    item.name = account.name
                    item.unionid = account.unionid
                    item.headUrl = account.headUrl
                }
            }else{
                if item.name == account.name{
                    hasSave = true
                    item.password = account.password
                    item.headUrl = account.headUrl
                    break
                }
            }
        }
        if hasSave == false{
            self.accounts.append(account)
        }
        //归档
        NSKeyedArchiver.archiveRootObject(self.accounts, toFile: self.accountPath)
    }
}
