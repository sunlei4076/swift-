//
//  ChineseInclude.h
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"
#import "PinYinForObjc.h"
#import "PinyinHelper.h"
#import "PinyinFormatter.h"
#import "HanyuPinyinOutputFormat.h"
#import "ChineseToPinyinResource.h"

@interface ChineseInclude : NSObject
+ (BOOL)isIncludeChineseInString:(NSString*)str;
@end
