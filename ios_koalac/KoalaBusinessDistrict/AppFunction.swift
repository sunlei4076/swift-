//
//  AppFunction.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/9.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

let kAppStoreRelease:String = "AppStore"
let kCompanyRelease:String = "Company"
//根据发布版本设置不同的值
//let kReleaseType:String = kCompanyRelease
let kReleaseType:String = kCompanyRelease

//屏幕宽度
let screenWidth = UIScreen.mainScreen().bounds.size.width
let screenHeight = UIScreen.mainScreen().bounds.size.height
//*********************************
//*********************************
//字体大小
let GBigFontSize:CGFloat = 17.0
let GNormalFontSize:CGFloat = 15.0
let GSmallFontSize:CGFloat = 13.0
let CustomFontName:String = "FZLTHJW--GB1-0"

func GGetBigCustomFont()->UIFont{
    return UIFont(name: CustomFontName, size: GBigFontSize)!
}

func GGetNormalCustomFont()->UIFont{
    return UIFont(name: CustomFontName, size: GNormalFontSize)!
}

func GGetSmallCustomFont()->UIFont{
    return UIFont(name: CustomFontName, size: GSmallFontSize)!
}

func GGetCustomFontWithSize(fontSize:CGFloat)->UIFont{
    return UIFont(name: CustomFontName, size: fontSize)!
}

//设置一个view中包含的label textfield 字体
func GSetFontInView(view:UIView, font:UIFont){
    for item in view.subviews{
        if item.isKindOfClass(UILabel){
            (item as! UILabel).font = font
        }else if item.isKindOfClass(UITextField){
            (item as! UITextField).font = font
        }else{
            GSetFontInView(item, font: font)
        }
    }
}
//*********************************
//*********************************
//统一背景
let GlobalBgColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)

//风格字体颜色
let GlobalStyleFontColor = UIColor(red: 240.0/255.0, green: 110.0/255.0, blue: 115.0/255.0, alpha: 1.0)

//风格按钮颜色
let GlobalStyleButtonColor = UIColor(red: 231.0/255.0, green: 67.0/255.0, blue: 76.0/255.0, alpha: 1.0)

//灰色字体颜色
let GlobalGrayFontColor = UIColor(red: 96.0/255.0, green: 96.0/255.0, blue: 96.0/255.0, alpha: 96.0/255.0)

//自定义不透明颜色
func GGetColor(r:CGFloat, g:CGFloat, b:CGFloat)->UIColor{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}
//*********************************
//*********************************
//显示提示框
func GShowAlertMessage(message:String){
    let alert = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
    alert.show()
}

func GShowAlertOrder(message:String){
    let alert = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "暂时不用")
    alert.addButtonWithTitle("去看看")
    alert.show()
}




//把时间段转成string；
func stringFromTimeInterval(interval: NSTimeInterval) -> String {
    let interval = Int(interval)
    let seconds = interval % 60
    let minutes = (interval / 60) % 60
    let hours = (interval / 3600)
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

//navigation back按钮
func GNavigationBack()->UIButton{
    let image = UIImage(named: "NavigationBack")
    let backBtn:UIButton = UIButton(type:UIButtonType.Custom)
    backBtn.setImage(image, forState: UIControlState.Normal)
    backBtn.frame = CGRectMake(0, 0, 30, 30)
    return backBtn
}

//navigation next按钮
func GNavigationNext()->UIButton{

    let nextBtn:UIButton = UIButton(type:UIButtonType.Custom)
    //    let image = UIImage(named: "NavigationBack")
//    backBtn.setImage(image, forState: UIControlState.Normal)
    nextBtn.setTitle("下一步", forState: UIControlState.Normal)
    nextBtn.frame = CGRectMake(0, 0, 60, 30)
    return nextBtn
}

//navigation style
func GNavgationStyle(nav:UINavigationBar){
    nav.translucent = false
    nav.barTintColor = GlobalStyleFontColor
    nav.tintColor = UIColor.whiteColor()
    nav.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(17.0), NSForegroundColorAttributeName: UIColor.whiteColor()]
}
//*********************************
//*********************************
//时间戳转时间
func GTimeSecondToSting(time:String,format:String)->String{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = format
    let seconds = (time as NSString).doubleValue
    let date = NSDate(timeIntervalSince1970: seconds)
    return dateFormatter.stringFromDate(date)
}

//时间转时间戳
func stringToTimeStamp(stringTime:String)->String {
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat = "yyyy-MM-dd"
    let date = dfmatter.dateFromString(stringTime)
    let dateStamp:NSTimeInterval = date!.timeIntervalSince1970
    let dateSt:Int = Int(dateStamp)
    return String(dateSt)
}

//图片缩放
func GFitSmallImage(originImage:UIImage, wantSize:CGSize, fitScale:Bool)->UIImage{
    var drawRect = CGRectZero
    if fitScale == true {
        //按宽高比例调整
        let imageSize = originImage.size
        let wscale = imageSize.width/wantSize.width
        let hscale = imageSize.height/wantSize.height
        let scale = (wscale>hscale) ? wscale:hscale
        let newSize = CGSizeMake(imageSize.width/scale, imageSize.height/scale);
        drawRect.size = newSize
        pprLog(newSize)
        
    }else{
        //不按宽高比调整
        drawRect.size = wantSize
    }
    UIGraphicsBeginImageContext(drawRect.size);
    originImage.drawInRect(drawRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}

class AppFunction: NSObject {
   
}

//开店提醒后弹出开店手机验证；
func openStorePoper(navCer:UINavigationController) {
    let popover = OpenShopPopover.instantiateFromNib()
    popover.show({ () -> () in
        let register = RegisteriPhoneIdentifyController(nibName:"RegisteriPhoneIdentifyController", bundle:nil)
        
//        调试关闭可调过手机验证；
//        let register = RegisterInfoViewController(nibName:"RegisterInfoViewController", bundle:nil)
        register.hidesBottomBarWhenPushed = true
        navCer.pushViewController(register, animated: true)
    })

}

func getBadgeView(number: Int) -> UIButton {
    var width : Float = 0.0
    switch number {
    case 0...9: width = 18;break
    case 10...99: width = 25;break
    case 100...999: width = 30;break
    default: width = 35;break
    }
    let numberStr: String = number > 999 ? "999+" : String(number)
    let badgeButton = UIButton(type: UIButtonType.Custom)
    badgeButton.setTitle(numberStr, forState: UIControlState.Normal)
    badgeButton.setBackgroundImage(UIImage(named: "new"), forState: UIControlState.Normal)
    badgeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    badgeButton.titleLabel?.font = UIFont(name: "FZLTHJW--GB1-0", size: 10)
    badgeButton.frame = CGRectMake(0, 0, CGFloat(width), 18)
    return badgeButton
}


//调试输出函数
func pprLog<T>(message: T,file: String = __FILE__,method: String = __FUNCTION__,line: Int = __LINE__)
{
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

