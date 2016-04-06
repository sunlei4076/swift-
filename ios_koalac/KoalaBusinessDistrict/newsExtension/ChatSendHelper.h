//
//  ChatSendHelper.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "KoalaBusinessDistrict-Swift.h"
#import <EaseMobSDKFull/EaseMob.h>
#import <UIKit/UIKit.h>


@interface ChatSendHelper : NSObject

+(EMMessage *)sendImageMessageWithImage:(UIImage *)image
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption;


#pragma mark - iDoctor客户端扩展消息

+ (EMMessage *)sendCustomTextMessageWithString:(NSString *)str toUsername:(NSString *)username;

+ (EMMessage *)sendCustomMedicalRecordWithString:(NSString *)str toUsername:(NSString *)username;

@end

