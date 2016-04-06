//
//  MessageReadManager.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/6/16.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MWPhotoBrowser.h>
//#import "MessageModel.h"
#import "KoalaBusinessDistrict-Swift.h"

typedef void (^FinishBlock)(BOOL success);
typedef void (^PlayBlock)(BOOL playing, MessageModel *messageModel);

@class EMChatFireBubbleView;
@interface MessageReadManager : NSObject<MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) FinishBlock finishBlock;

//@property (strong, nonatomic) MessageModel *audioMessageModel;

+ (id)defaultManager;

//default
- (void)showBrowserWithImages:(NSArray *)imageArray;


@end

