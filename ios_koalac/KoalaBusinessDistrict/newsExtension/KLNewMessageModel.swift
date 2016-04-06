//
//  KLNewMessageModel.swift
//  KoalaBusinessDistrict
//
//  Created by life on 15/12/30.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class KLNewMessageModel: NSObject {
    
    // //缓存数据模型对应的cell的高度，只需要计算一次并赋值，以后就无需计算了
    var cellHeight:CGFloat = -1
    ////SDK中的消息
    //    var message:EMMessage?
    ////消息的第一个消息体
    var firstMessageBody:CGFloat = -1
    //     //消息ID
    var messageId:String = ""
    // //消息类型
    var bodyType:MessageBodyType = MessageBodyType.eMessageBodyType_Text
    //      //消息发送状态
    var messageStatus:MessageDeliveryState = MessageDeliveryState.eMessageDeliveryState_Pending
    //// 消息类型（单聊，群里，聊天室）
    var messageType:EMMessageType = EMMessageType.eMessageTypeChat
    //    //是否已读
    ////    var isMessageRead:Bool
    //    //是否是当前登录者发送的消息
    var isSender:Bool = false
    ////消息显示的昵称
    var nickname:String = ""
    ////消息显示的头像的网络地址
    //    var avatarURLPath:String = ""
    ////消息显示的头像
    ////    var avatarImage:UIImage?
    //    //文本消息：文本
    var text:String = ""
    //    //文本消息：文本
    ////    var attrBody:NSAttributedString?
    //    //地址消息：地址描述
    var address:String = ""
    ////=========================
    var latitude:Double = 0.0//地址消息：地址经度
    var longitude:Double = 0.0//地址消息：地址纬度
    //    var failImageName:String = ""//获取图片失败后显示的图片
    var imageSize:CGSize = CGSizeMake(0.0, 0.0)//图片消息：图片 原图 的宽高
    var thumbnailImageSize:CGSize = CGSizeMake(0.0, 0.0)//图片消息：图片 缩略图 的宽高
    var image:UIImage?//图片消息：图片原图
    var thumbnailImage:UIImage?   //图片消息：图片缩略图
    ////=========================
    var isMediaPlaying:Bool = false //多媒体消息：是否正在播放
    var isMediaPlayed:Bool = false//多媒体消息：是否播放过
    var mediaDuration:Int = 0//多媒体消息：长度
    ////=========================
    ////    var fileIconName:String?  //文件消息：文件图标
    ////    var fileName:String?//文件消息：文件名称
    ////    var fileSizeDes:String?//文件消息：文件大小描述
    ////     var fileSize:CGFloat?//文件消息：文件大小
    ////    var progress:CGFloat?//带附件的消息的上传或下载进度
    var fileLocalPath:String = "" //消息：附件本地地址
    ////    var thumbnailFileLocalPath:String? //消息：压缩附件本地地址
    var fileURLPath:String = ""//消息：附件下载地址
    ////    var thumbnailFileURLPath:String?//消息：压缩附件下载地址
    
    convenience init(message:EMMessage){
        self.init()
        self.cellHeight = -1
        //        self.message = message
        let firstMessageBody = message.messageBodies.first
        self.isMediaPlaying = false
        let userInfo = EaseMob.sharedInstance().chatManager.loginInfo as! Dictionary<String,AnyObject>
        let login = userInfo["username"] as? String
        self.nickname = (message.messageType == EMMessageType.eMessageTypeChat) ? message.from : message.groupSenderName
        self.isSender = (login == self.nickname) ? true :false
        
        if firstMessageBody is EMTextMessageBody {
            let textBody = firstMessageBody as! EMTextMessageBody
            self.text = textBody.text
            //消息体内扩展模型
            if message.ext != nil
            {
                let messageExt = message.ext as! Dictionary<String,AnyObject>
                let modelExt = XHMessageExtModel.init(ext:messageExt)
                pprLog(modelExt)
            }
            
        }else if firstMessageBody is EMImageMessageBody {
            let imgMessageBody = firstMessageBody as! EMImageMessageBody
            self.thumbnailImageSize = imgMessageBody.thumbnailSize
            self.thumbnailImage = UIImage.init(contentsOfFile: imgMessageBody.thumbnailLocalPath)
            self.imageSize = imgMessageBody.size
            self.fileLocalPath = imgMessageBody.localPath
            if self.isSender == true {
                self.image = UIImage.init(contentsOfFile: imgMessageBody.thumbnailLocalPath)
            } else {
                self.fileURLPath = imgMessageBody.remotePath;
            }
            
        }else if firstMessageBody is EMLocationMessageBody{
            let locationBody = firstMessageBody as! EMLocationMessageBody
            self.address = locationBody.address
            self.latitude = locationBody.latitude
            self.longitude = locationBody.longitude
            
        } else if firstMessageBody is EMVoiceMessageBody{
            let voiceBody = firstMessageBody as! EMVoiceMessageBody
            self.mediaDuration = voiceBody.duration
            self.isMediaPlayed = false
            if (message.ext != nil) {
                self.isMediaPlayed = message.ext["isPlayed"]!.boolValue
            }
            // 音频路径
            self.fileLocalPath = voiceBody.localPath;
            self.fileURLPath = voiceBody.remotePath;
        }
        
    }
    
}
