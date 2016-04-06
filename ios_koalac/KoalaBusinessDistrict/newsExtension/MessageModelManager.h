//
//  MessageModelManager.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EaseMobSDKFull/EaseMob.h>

@interface MessageModelManager : NSObject

+ (id)modelWithMessage:(EMMessage *)message;

@end
