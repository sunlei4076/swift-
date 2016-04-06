//
//  NSDateFormatter+Category.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Category)

+ (id)dateFormatter;
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;

+ (id)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end

