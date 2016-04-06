//
//  MessageModelManager.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "MessageModelManager.h"
//#import "ConvertToCommonEmoticonsHelper.h"
//#import "EaseMob.h"
#import "MessageModel.h"

@implementation MessageModelManager

+ (id)modelWithMessage:(EMMessage *)message
{
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    BOOL isSender = [login isEqualToString:message.from] ? YES : NO;//设置发送信息的是发送者还是接受者，NO是对方，YES是自己
    //暂时默认是自己
    MessageModel *model = [[MessageModel alloc] init];
    model.isRead = message.isRead;
    model.messageBody = messageBody;
    model.message = message;
    model.type = messageBody.messageBodyType;
    model.messageId = message.messageId;
    model.isSender = isSender;
//    model.isPlaying = NO;//没有音频
//    model.isChatGroup = message.isGroup;
//    if (model.isChatGroup) {
//        model.username = message.groupSenderName;
//    }
//    else{
        model.username = message.from;
//    }
    
    if (isSender) {
        model.headImageURL = nil;
        model.status = message.deliveryState;
//        NSLog(@"%ld",(long)message.deliveryState);
    }
    else{
        model.headImageURL = nil;
        model.status = eMessageDeliveryState_Delivered;
    }
    
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
//            // 表情映射。
//            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
//                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
//            model.content = didReceiveText;
        }
            break;
        case eMessageBodyType_Image:
        {
            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)messageBody;
            model.thumbnailSize = imgMessageBody.thumbnailSize;
            model.size = imgMessageBody.size;
//            model.localPath = imgMessageBody.localPath;//TODO这个不知道干什么的，先注释
            model.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            if (isSender)
            {
                model.image = [UIImage imageWithContentsOfFile:imgMessageBody.localPath];
            }else {
                model.imageRemoteURL = [NSURL URLWithString:imgMessageBody.remotePath];
            }
        }
            break;
//        case eMessageBodyType_Location:
//        {
//            model.address = ((EMLocationMessageBody *)messageBody).address;
//            model.latitude = ((EMLocationMessageBody *)messageBody).latitude;
//            model.longitude = ((EMLocationMessageBody *)messageBody).longitude;
//        }
//            break;
//        case eMessageBodyType_Voice:
//        {
//            model.time = ((EMVoiceMessageBody *)messageBody).duration;
//            model.chatVoice = (EMChatVoice *)((EMVoiceMessageBody *)messageBody).chatObject;
//            if (message.ext) {
//                NSDictionary *dict = message.ext;
//                BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
//                model.isPlayed = isPlayed;
//            }else {
//                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
//                message.ext = dict;
//                [[EaseMob sharedInstance].chatManager saveMessage:message];
//            }
//            // 本地音频路径
//            model.localPath = ((EMVoiceMessageBody *)messageBody).localPath;
//            model.remotePath = ((EMVoiceMessageBody *)messageBody).remotePath;
//        }
//            break;
//        case eMessageBodyType_Video:{
//            EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody*)messageBody;
//            model.thumbnailSize = videoMessageBody.size;
//            model.size = videoMessageBody.size;
//            model.localPath = videoMessageBody.localPath;
//            model.thumbnailImage = [UIImage imageWithContentsOfFile:videoMessageBody.thumbnailLocalPath];
//        }
//            break;
        default:
            break;
    }
    
    return model;
}

@end

