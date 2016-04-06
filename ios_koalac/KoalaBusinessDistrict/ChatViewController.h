//
//  ChatViewController.h
//  KoalaBusinessDistrict
//
//  Created by twksky on 15/12/28.
//  Copyright © 2015年 koalac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
- (instancetype)initWithUserID:(NSString *)userID;//貌似给消息页用的
-(void)sendTextMessage:(NSString *)textMessage;
@end
