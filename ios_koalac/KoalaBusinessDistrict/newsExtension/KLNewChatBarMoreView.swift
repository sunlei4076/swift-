//
//  KLNewChatBarMoreView.swift
//  KoalaBusinessDistrict
//
//  Created by life on 15/12/29.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class KLNewChatBarMoreView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //1.类似宏定义
    let CHAT_BUTTON_SIZE:CGFloat = 60
    let INSETS = 8
    //2.属性声明
    var photoButton:UIButton? //照片
    var takePhotoButton:UIButton?//拍照
    var orderButton:UIButton?//订单
    //3.闭包回调声明
    var photoButtonBlock:((newChatBarMoreView:KLNewChatBarMoreView)->())? //照片
    var takePhotoButtonBlock:((newChatBarMoreView:KLNewChatBarMoreView)->())? //拍照
    var orderButtonBlock:((newChatBarMoreView:KLNewChatBarMoreView)->())? //订单
    //4.方法实现
    //@1初始化
    func setupSubviews(){
        self.backgroundColor = UIColor.init(red: 148.0/255, green: 148.0/255, blue: 148.0/255, alpha: 1)

         var buttonIndex:CGFloat = 0
        self.addSubview(self.getcontainerView(buttonIndex, imageName: "new_picture", clickAction: "photoAction", titleName: "图片"))
            buttonIndex++;
        self.addSubview(self.getcontainerView(buttonIndex, imageName: "new_takePhone", clickAction: "takePhotoAction", titleName: "拍照"))
        buttonIndex++;
        self.addSubview(self.getcontainerView(buttonIndex, imageName: "new_order", clickAction: "orderAction", titleName: "订单"))
        buttonIndex++;
    }
    //返回一个包含uibutton和Label的uiview
    func getcontainerView(buttonIndex:CGFloat,imageName:String,clickAction:Selector,titleName:String)->UIView{
        let  insets = (screenWidth - 4 * CHAT_BUTTON_SIZE) / 5

        let containerPhotoView:UIView = UIView.init(frame: CGRectMake(insets * (buttonIndex%4 + 1) + CHAT_BUTTON_SIZE * (buttonIndex%4), buttonIndex > 3 ?CHAT_BUTTON_SIZE + 40.0:10, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE + 30.0))
        pprLog(containerPhotoView.frame)
        //1.图片
        containerPhotoView.addSubview(self.getSubButton(imageName, clickAction: clickAction))
        containerPhotoView.addSubview(self.getSubLabel(titleName))
        return  containerPhotoView
    }


    //返回一个按钮
    func getSubButton(imageName:String,clickAction:Selector)->UIButton{
        self.photoButton = UIButton.init(type: UIButtonType.Custom)
        self.photoButton?.frame = CGRectMake(0, 0, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)
        self.photoButton?.setImage(UIImage.init(named:imageName), forState: UIControlState.Normal)
        self.photoButton?.addTarget(self, action:clickAction, forControlEvents: UIControlEvents.TouchUpInside)
        return self.photoButton!
    }
    //返回一个label
    func getSubLabel(titleName:String)-> UILabel
    {
        let photoTitleLabel:UILabel = UILabel.init(frame: CGRectMake(0, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 30.0))
        photoTitleLabel.text = titleName
        photoTitleLabel.textColor = UIColor.blackColor()
        photoTitleLabel.textAlignment = NSTextAlignment.Center
        photoTitleLabel.font = UIFont.systemFontOfSize(12)
        return photoTitleLabel
    }

    //@2按钮点击方法
    func photoAction(){
        if (photoButtonBlock != nil) {
            self.photoButtonBlock!(newChatBarMoreView:self)
        }

    }
    
    func takePhotoAction(){
        if (takePhotoButtonBlock != nil) {
            self.takePhotoButtonBlock!(newChatBarMoreView:self)
        }

    }
    
    func orderAction(){
        if (orderButtonBlock != nil) {
            self.orderButtonBlock!(newChatBarMoreView:self)
        }

    }

}
