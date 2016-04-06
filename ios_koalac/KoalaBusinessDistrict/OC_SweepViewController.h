//
//  OC_SweepViewController.h
//  koalac_PPM
//
//  Created by liuny on 15/7/7.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@protocol SweepDelegate <NSObject>

-(void)sweepSuccess:(NSString *)readerStr;

@end

@interface OC_SweepViewController : UIViewController<ZBarReaderViewDelegate>
@property (weak, nonatomic) id<SweepDelegate> delegate;
@end
