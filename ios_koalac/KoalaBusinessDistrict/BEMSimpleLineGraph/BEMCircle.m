//
//  BEMCircle.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "BEMCircle.h"

@implementation BEMCircle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
#if 1
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    [self.Pointcolor set];
    CGContextFillPath(ctx);
//    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGRect smallPoint = CGRectMake((rect.size.width-3)/2, (rect.size.height-3)/2, 3, 3);
    CGContextAddEllipseInRect(ctx, smallPoint);
    UIColor *smallColor = [UIColor whiteColor];
    [smallColor set];
    CGContextFillPath(ctx);
#else
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    [self.Pointcolor set];
    CGContextFillPath(ctx);
#endif
}

@end