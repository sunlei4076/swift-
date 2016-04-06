//
//  SYCalendarMonth.m
//  Seeyou
//
//  Created by upin on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import "LKCalendarMonth.h"

@implementation LKCalendarMonth

-(void)startLoadingView
{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, SYCC_MonthHeight)];
    _contentView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:_contentView];
    
    self.dayViews = [NSMutableArray arrayWithCapacity:6*7];

    float lastRowY = SYCC_DayOffsetHeight;
    
    float dayWidth = (self.contentView.frame.size.width - 8*SYCC_DayOffsetWidth)/7;
    
    for (int row =0; row<6; row++) {
        float lastColumnX = SYCC_DayOffsetWidth;
        for (int column = 0; column < 7; column ++) {
            
            CGRect dayViewFrame = CGRectMake(lastColumnX,lastRowY, dayWidth, SYCC_DayHeight);
            
            UIView* dayView = nil;
            if([self.delegate respondsToSelector:@selector(calendarMonth:createDayViewWithFrame:)])
            {
                dayView = [self.delegate calendarMonth:self createDayViewWithFrame:dayViewFrame];
            }
            if(dayView == nil)
            {
                dayView = [[LKCalendarDayView alloc]initWithFrame:dayViewFrame];
                if([self.delegate conformsToProtocol:@protocol(LKCalendarDayViewDelegate)])
                {
                    ((LKCalendarDayView*)dayView).delegate = (id)self.delegate;
                }
            }
            dayView.frame = dayViewFrame;
            
            [_contentView addSubview:dayView];
            [_dayViews addObject:dayView];
            
            lastColumnX += (SYCC_DayOffsetWidth+dayWidth);
        }
        lastRowY +=(SYCC_DayHeight+SYCC_DayOffsetHeight);
    }
}
-(void)setDelegate:(id<LKCalendarMonthDelegate>)delegate
{
    _delegate = delegate;
    if([_delegate conformsToProtocol:@protocol(LKCalendarDayViewDelegate)])
    {
        if([_delegate respondsToSelector:@selector(calendarMonth:createDayViewWithFrame:)] == NO)
        {
            for (LKCalendarDayView* dayView in _dayViews) {
                dayView.delegate = (id)_delegate;
            }
        }
    }
}
-(void)setCurrentMonth:(NSDateComponents *)currentMonth
{
    if(currentMonth.month > 12 || currentMonth.month < 1)
    {
        NSDate* date = [currentLKCalendar dateFromComponents:currentMonth];
        currentMonth = [currentLKCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    }
    
    if(_currentMonth.year == currentMonth.year && _currentMonth.month == currentMonth.month)
        return;
    
    _currentMonth = [currentMonth copy];
    [self reloadMonthViewDate];
}

-(void)reloadMonthViewDate
{
    
    NSDateComponents* dateComponents = [_currentMonth copy];
    dateComponents.day = 1;
    
    //获得当前月的第一天时间
    NSDate* firstDay =  [currentLKCalendar dateFromComponents:dateComponents];
    
    //获得第一天 是周几
    int firstWeekDay = [currentLKCalendar components:NSCalendarUnitWeekday fromDate:firstDay].weekday;
    
    //获取第一天 在日历中的位置。。     （根据你的设置去换算周几）:_firstDayWeek  可设置的
    int firstDayPosition = (firstWeekDay - _firstDayWeek + 8)%8;
    
    //第一行第一天  跟  当前月第一天    的差距天数
    int dayDiff = 1 - firstDayPosition + 1;
    
    int size = _dayViews.count;
    NSMutableArray* dateArray = [NSMutableArray arrayWithCapacity:size];
    for (int i=0;i<size; i++) {
        //剩下的简单了  将第一行第一天  不断的加一  然后保存起来  就可以获得整个月的 时间集合了
        dateComponents.day = dayDiff;
        NSDate* date = [currentLKCalendar dateFromComponents:dateComponents];
        [dateArray addObject:date];
        
        dayDiff ++;
    }
    [self.dates removeAllObjects];
    self.dates = [NSMutableArray arrayWithArray:dateArray];
    
    //有时间集合了 剩下的 就是显示了
    [self refreshMonthView];
}

-(void)refreshMonthView
{
    if([self.delegate respondsToSelector:@selector(calendarMonthRefreshView:)])
    {
        [self.delegate calendarMonthRefreshView:self];
    }
    else
    {
        for (int i =0,size=_dayViews.count; i<size; i++) {
            NSDate* date = [_dates objectAtIndex:i];
            id dayView = [_dayViews objectAtIndex:i];
            
            if([self.delegate respondsToSelector:@selector(calendarMonth:dayView:date:)])
            {
                [self.delegate calendarMonth:self dayView:dayView date:date];
            }
            else if([dayView isKindOfClass:[LKCalendarDayView class]])
            {
                LKCalendarDayView* dd = dayView;
                dd.date = date;
            }
        }
    }
    if([self.delegate respondsToSelector:@selector(calendarMonthDidReload:)])
    {
        [self.delegate calendarMonthDidReload:self];
    }
}

-(int)getValidRow
{
    int row = 5;
    while (row > 0) {
        NSDate* date = [_dates objectAtIndex:row*7];
        NSDateComponents* com = [currentLKCalendar components:NSCalendarUnitMonth fromDate:date];
        if(com.month != _currentMonth.month){
            row--;
        }
        else{
            return (row + 1);
        }
    }
    return -1;
}
-(id)dayViewWithDate:(NSDate *)date
{
    int index = [self.dates indexOfObject:date];
    return [self.dayViews objectAtIndex:index];
}
@end
