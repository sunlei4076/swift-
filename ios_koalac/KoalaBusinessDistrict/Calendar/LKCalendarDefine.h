//
//  LKCalendarDefine
//  LJH
//
//  Created by LJH on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import "LKCalendarView.h"
#import "LKCalendarMonth.h"
#import "LKCalendarDayView.h"


//#define SYCC_DayWidth 43.5f
#define SYCC_DayHeight 38.0f

#define SYCC_DayOffsetWidth 1.0f
#define SYCC_DayOffsetHeight 1.0f

//#define SYCC_MonthWidth   (SYCC_DayWidth*7 + SYCC_DayOffsetWidth*8)
#define SYCC_MonthHeight  (SYCC_DayHeight*6 + SYCC_DayOffsetHeight*7)


#define currentLKCalendar [NSCalendar autoupdatingCurrentCalendar]


#define monthDiffWithDateComponents(com1,com2) ((com2.year - com1.year)*12 + (com2.month - com1.month))
#define getYearMonthDateComponents(date) [currentLKCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date]

//风格字体颜色
#define GlobalStyleFontColor [UIColor colorWithRed:240.0/255.0 green:110.0/255.0 blue:115.0/255.0 alpha:1.0]

//设置颜色
#define kGetColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]