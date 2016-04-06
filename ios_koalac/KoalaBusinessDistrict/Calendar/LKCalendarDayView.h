//
//  SYCalendarDayView.h
//  Seeyou
//
//  Created by upin on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKCalendarDayView;
@protocol LKCalendarDayViewDelegate <NSObject>
@optional
-(void)calendarDayViewWillSelected:(LKCalendarDayView*)dayView;
@end

typedef enum
{
    CalendarDay_Normal = 0, //显示日期，可以选中
    CalendarDay_Disable,    //显示日期，但是不能选中
    CalendarDay_Selected,   //日期选中状态
    CalendarDay_None        //没有日期
}CalendarDay_Type;


@interface LKCalendarDayView : UIView

@property(weak,nonatomic)id<LKCalendarDayViewDelegate>delegate;

@property(nonatomic,getter = isSelected) BOOL selected;
@property(strong,nonatomic)NSDate* date;
@property (nonatomic, strong) UIColor *selectedBgColor;
@property (nonatomic, strong) UIColor *disableBgColor;
@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *noneBgColor;
@property (nonatomic, strong) UIFont *dayFont;
@property (nonatomic, strong) UIColor *selectedFontColor;
@property (nonatomic, strong) UIColor *disableFontColor;
@property (nonatomic, strong) UIColor *normalFontColor;

@property(strong,nonatomic)UILabel* lb_date;

-(void)setCalDayShowWithType:(CalendarDay_Type)type;
@end