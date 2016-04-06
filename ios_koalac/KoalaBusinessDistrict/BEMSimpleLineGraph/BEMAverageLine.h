//
//  BEMAverageLine.h
//  SimpleLineChart
//
//  Created by Sam Spencer on 4/7/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

//@import UIKit;
#if __has_feature(objc_modules)
// We recommend enabling Objective-C Modules in your project Build Settings for numerous benefits over regular #imports
@import Foundation;
@import UIKit;
@import CoreGraphics;
#else
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#endif

/// A line displayed horizontally across the graph at the average y-value
@interface BEMAverageLine : NSObject


/// When set to YES, an average line will be displayed on the line graph
@property (nonatomic) BOOL enableAverageLine;


/// The color of the average line
@property (strong, nonatomic) UIColor *color;


/// The Y-Value of the average line. This could be an average, a median, a mode, sum, etc.
@property (nonatomic) CGFloat yValue;


/// The alpha of the average line
@property (nonatomic) CGFloat alpha;


/// The width of the average line
@property (nonatomic) CGFloat width;


/// Dash pattern for the average line
@property (strong, nonatomic) NSArray *dashPattern;


@end
