//
//  SYCalendarDayView.m
//  Seeyou
//
//  Created by upin on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import "LKCalendarDayView.h"
#import "LKCalendarDefine.h"

@interface LKCalendarDayView()
@property(weak,nonatomic)UIImageView* selectedView;
@end

@implementation LKCalendarDayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Default
        self.noneBgColor = [UIColor whiteColor];
        self.disableBgColor = kGetColor(234.0, 234.0, 234.0);
        self.selectedBgColor = kGetColor(235.0, 66.0, 72.0);
        self.normalBgColor = [UIColor whiteColor];
        self.disableFontColor = kGetColor(140.0, 140.0, 140.0);
        self.selectedFontColor = [UIColor whiteColor];
        self.normalFontColor = kGetColor(94.0, 94.0, 94.0);
        self.dayFont = [UIFont systemFontOfSize:16];
        
        _lb_date = [UILabel new];
        _lb_date.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _lb_date.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lb_date];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setCalDayShowWithType:CalendarDay_Selected];
    if([self.delegate respondsToSelector:@selector(calendarDayViewWillSelected:)])
    {
       [self.delegate calendarDayViewWillSelected:self];
    }
}

-(void)setDate:(NSDate *)date
{
    _date = [date copy];
    
    NSDateComponents* dateComponents = [currentLKCalendar components:NSCalendarUnitDay fromDate:_date];
    _lb_date.text = [NSString stringWithFormat:@"%d",dateComponents.day];
}

-(void)setCalDayShowWithType:(CalendarDay_Type)type
{
    switch (type) {
        case CalendarDay_Disable:
            self.userInteractionEnabled = NO;
            self.backgroundColor = self.disableBgColor;
            self.lb_date.textColor = self.disableFontColor;
            break;
        case CalendarDay_None:
            self.userInteractionEnabled = NO;
            self.backgroundColor = self.noneBgColor;
            self.lb_date.text = @"";
            break;
        case CalendarDay_Normal:
            self.selected = NO;
            self.userInteractionEnabled = YES;
            self.backgroundColor = self.normalBgColor;
            self.lb_date.textColor = self.normalFontColor;
            break;
        case CalendarDay_Selected:
            if(self.selected == NO){
                self.selected = YES;
                self.userInteractionEnabled = YES;
                self.backgroundColor = self.selectedBgColor;
                self.lb_date.textColor = self.selectedFontColor;
            }
            break;
        default:
            break;
    }
}
@end


