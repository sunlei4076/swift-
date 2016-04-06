//
//  BEMLine.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "BEMLine.h"
#import "BEMSimpleLineGraphView.h"

#if CGFLOAT_IS_DOUBLE
#define CGFloatValue doubleValue
#else
#define CGFloatValue floatValue
#endif

@implementation BEMLine

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _enableLeftReferenceFrameLine = YES;
        _enableBottomReferenceFrameLine = YES;
        _interpolateNullValues = YES;
    }
    return self;
}

//------------------------//
//---------画背景网格------//
//------------------------//
-(void)drawBG
{
    UIBezierPath *referenceFramePath = [UIBezierPath bezierPath];
    
    referenceFramePath.lineCapStyle = kCGLineCapButt;
    referenceFramePath.lineWidth = 0.5;
    
    CGFloat height = (self.bounds.size.height-2) / 9;
    CGFloat width = self.bounds.size.width / 10;
    for(int i=0;i<=9;i++){
        [referenceFramePath moveToPoint:CGPointMake(0, (self.bounds.size.height - 2) - i*height)];
        [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width, (self.frame.size.height - 2) - i*height)];
    }
    
    for(int i=0;i<=10;i++){
        [referenceFramePath moveToPoint:CGPointMake(width*i, 0)];
        [referenceFramePath addLineToPoint:CGPointMake(width*i, self.frame.size.height - 2)];
    }
    [referenceFramePath closePath];
    
#if 1
    CAShapeLayer *referenceLinesPathLayer = [CAShapeLayer layer];
    referenceLinesPathLayer.frame = self.bounds;
    referenceLinesPathLayer.path = referenceFramePath.CGPath;
    referenceLinesPathLayer.opacity = self.lineAlpha == 0 ? 0.1 : self.lineAlpha/2;
    referenceLinesPathLayer.fillColor = nil;
    referenceLinesPathLayer.lineWidth = self.lineWidth/2;
    UIColor *lineColor = [UIColor grayColor];
    referenceLinesPathLayer.strokeColor = lineColor.CGColor;
    
    [self.layer addSublayer:referenceLinesPathLayer];
#else
    [referenceFramePath stroke];
#endif
}

//------------------------//
//-----画X轴空心圆点与线-----//
//------------------------//
-(void)drawTest
{
    CGFloat xIndexScale = self.frame.size.width/([self.arrayOfPoints count] - 1);
    for(int i=0;i<self.arrayOfPoints.count;i++){
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect rect = CGRectMake(xIndexScale*i-2, self.bounds.size.height-4, 4, 4);
        CGContextAddEllipseInRect(ctx, rect);
        [[UIColor redColor] set];
        CGContextDrawPath(ctx, kCGPathStroke);
        
        if(i<self.arrayOfPoints.count-1){
        CGPoint apoints[2];
        apoints[0] = CGPointMake(xIndexScale*i+2, self.bounds.size.height-2);
        apoints[1] = CGPointMake(xIndexScale*(i+1)-2, self.bounds.size.height-2);
        [[UIColor whiteColor] set];
        CGContextAddLines(ctx, apoints, 2);
        CGContextDrawPath(ctx, kCGPathStroke);
        }
    }
}

- (void)drawRect:(CGRect)rect {
    
    [self drawBG];
    [self drawTest];
    //----------------------------//
    //---- Draw Refrence Lines ---//
    //----------------------------//
    UIBezierPath *verticalReferenceLinesPath = [UIBezierPath bezierPath];
    UIBezierPath *horizontalReferenceLinesPath = [UIBezierPath bezierPath];
    UIBezierPath *referenceFramePath = [UIBezierPath bezierPath];
    
    verticalReferenceLinesPath.lineCapStyle = kCGLineCapButt;
    verticalReferenceLinesPath.lineWidth = 0.7;
    
    horizontalReferenceLinesPath.lineCapStyle = kCGLineCapButt;
    horizontalReferenceLinesPath.lineWidth = 0.7;
    
    referenceFramePath.lineCapStyle = kCGLineCapButt;
    referenceFramePath.lineWidth = 0.7;
    
    if (self.enableRefrenceFrame == YES) {
        if (self.enableBottomReferenceFrameLine) {
            // Bottom Line
            [referenceFramePath moveToPoint:CGPointMake(0, self.frame.size.height)];
            [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        }
        
        if (self.enableLeftReferenceFrameLine) {
            // Left Line
            [referenceFramePath moveToPoint:CGPointMake(0+self.lineWidth/4, self.frame.size.height)];
            [referenceFramePath addLineToPoint:CGPointMake(0+self.lineWidth/4, 0)];
        }
        
        if (self.enableTopReferenceFrameLine) {
            // Top Line
            [referenceFramePath moveToPoint:CGPointMake(0+self.lineWidth/4, 0)];
            [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
        }
        
        if (self.enableRightReferenceFrameLine) {
            // Right Line
            [referenceFramePath moveToPoint:CGPointMake(self.frame.size.width - self.lineWidth/4, self.frame.size.height)];
            [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width - self.lineWidth/4, 0)];
        }
        
        [referenceFramePath closePath];
    }
    
    if (self.enableRefrenceLines == YES) {
        if (self.arrayOfVerticalRefrenceLinePoints.count > 0) {
            for (NSNumber *xNumber in self.arrayOfVerticalRefrenceLinePoints) {
                CGFloat xValue;
                if (self.verticalReferenceHorizontalFringeNegation != 0.0) {
                    if ([self.arrayOfVerticalRefrenceLinePoints indexOfObject:xNumber] == 0) { // far left reference line
                        xValue = [xNumber floatValue] + self.verticalReferenceHorizontalFringeNegation;
                    } else if ([self.arrayOfVerticalRefrenceLinePoints indexOfObject:xNumber] == [self.arrayOfVerticalRefrenceLinePoints count]-1) { // far right reference line
                        xValue = [xNumber floatValue] - self.verticalReferenceHorizontalFringeNegation;
                    } else xValue = [xNumber floatValue];
                } else xValue = [xNumber floatValue];
                
                CGPoint initialPoint = CGPointMake(xValue, self.frame.size.height);
                CGPoint finalPoint = CGPointMake(xValue, 0);
                
                [verticalReferenceLinesPath moveToPoint:initialPoint];
                [verticalReferenceLinesPath addLineToPoint:finalPoint];
            }
            
            [verticalReferenceLinesPath closePath];
        }
        
        if (self.arrayOfHorizontalRefrenceLinePoints.count > 0) {
            for (NSNumber *yNumber in self.arrayOfHorizontalRefrenceLinePoints) {
                CGPoint initialPoint = CGPointMake(0, [yNumber floatValue]);
                CGPoint finalPoint = CGPointMake(self.frame.size.width, [yNumber floatValue]);
                
                [horizontalReferenceLinesPath moveToPoint:initialPoint];
                [horizontalReferenceLinesPath addLineToPoint:finalPoint];
            }
            
            [horizontalReferenceLinesPath closePath];
        }
    }
    
    
    //----------------------------//
    //----- Draw Average Line ----//
    //----------------------------//
    UIBezierPath *averageLinePath = [UIBezierPath bezierPath];
    if (self.averageLine.enableAverageLine == YES) {
        averageLinePath.lineCapStyle = kCGLineCapButt;
        averageLinePath.lineWidth = self.averageLine.width;
        
        CGPoint initialPoint = CGPointMake(0, self.averageLineYCoordinate);
        CGPoint finalPoint = CGPointMake(self.frame.size.width, self.averageLineYCoordinate);
        
        [averageLinePath moveToPoint:initialPoint];
        [averageLinePath addLineToPoint:finalPoint];
        
        [averageLinePath closePath];
    }
    
    
    //----------------------------//
    //------ Draw Graph Line -----//
    //----------------------------//
    CGPoint CP1;
    CGPoint CP2;
    
    // BEZIER CURVE
    if (self.bezierCurveIsEnabled == YES) {
        // First control point
        CP1 = CGPointMake(self.P1.x + (self.P2.x - self.P1.x)/3,
                          self.P1.y - (self.P1.y - self.P2.y)/3 - (self.P0.y - self.P1.y)*0.3);
        
        // Second control point
        CP2 = CGPointMake(self.P1.x + 2*(self.P2.x - self.P1.x)/3,
                          (self.P1.y - 2*(self.P1.y - self.P2.y)/3) + (self.P2.y - self.P3.y)*0.3);
    }
    
    // LINE
    UIBezierPath *line = [UIBezierPath bezierPath];
    UIBezierPath *fillTop = [UIBezierPath bezierPath];
    UIBezierPath *fillBottom = [UIBezierPath bezierPath];
    
    CGPoint p0;
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    CGFloat tensionBezier1 = 0.3;
    CGFloat tensionBezier2 = 0.3;
    CGFloat xIndexScale = self.frame.size.width/([self.arrayOfPoints count] - 1);
    
    [fillBottom moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [fillBottom addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [fillTop moveToPoint:CGPointMake(self.frame.size.width, 0)];
    [fillTop addLineToPoint:CGPointMake(0, 0)];
    
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:self.arrayOfPoints.count];
    for (int i = 0; i < self.arrayOfPoints.count; i++) {
        CGPoint value = CGPointMake(xIndexScale * i, [self.arrayOfPoints[i] CGFloatValue]);
        if (value.y != BEMNullGraphValue || !self.interpolateNullValues) {
            [points addObject:[NSValue valueWithCGPoint:value]];
        }
    }
    
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    
    for (int i = 0; i < points.count - 1; i++) {
        p1 = [[points objectAtIndex:i] CGPointValue];
        p2 = [[points objectAtIndex:i + 1] CGPointValue];
        
        if (!self.interpolateNullValues && (p1.y == BEMNullGraphValue || p2.y == BEMNullGraphValue)) continue;
        
        if (self.disableMainLine == NO) [line moveToPoint:p1];
        [fillBottom addLineToPoint:p1];
        [fillTop addLineToPoint:p1];
        
        if (self.bezierCurveIsEnabled == YES) {
            const CGFloat maxTension = 1.0f / 3.0f;
            tensionBezier1 = maxTension;
            tensionBezier2 = maxTension;
            
            if (i > 0) { // Exception for first line because there is no previous point
                p0 = previousPoint1;
                if (p2.y - p1.y == p1.y - p0.y) tensionBezier1 = 0;
            } else {
                tensionBezier1 = 0;
                p0 = p1;
            }
            
            if (i < points.count - 2) { // Exception for last line because there is no next point
                p3 = [[points objectAtIndex:i + 2] CGPointValue];
                if (p3.y - p2.y == p2.y - p1.y) tensionBezier2 = 0;
            } else {
                p3 = p2;
                tensionBezier2 = 0;
            }
            
            // The tension should never exceed 0.3
            if (tensionBezier1 > maxTension) tensionBezier1 = maxTension;
            if (tensionBezier2 > maxTension) tensionBezier2 = maxTension;
            
            // First control point
            CP1 = CGPointMake(p1.x + (p2.x - p1.x)/3,
                              p1.y - (p1.y - p2.y)/3 - (p0.y - p1.y)*tensionBezier1);
            
            // Second control point
            CP2 = CGPointMake(p1.x + 2*(p2.x - p1.x)/3,
                              (p1.y - 2*(p1.y - p2.y)/3) + (p2.y - p3.y)*tensionBezier2);
            
            if (self.disableMainLine == NO) [line addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
            [fillBottom addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
            [fillTop addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
        } else {
            if (self.disableMainLine == NO) [line addLineToPoint:p2];
            [fillBottom addLineToPoint:p2];
            [fillTop addLineToPoint:p2];
        }
        
        previousPoint1 = p1;
        previousPoint2 = p2;
    }
    
    //-------------------------//
    //-------点与x轴之间的虚线-------------//
    //-------------------------//
    UIBezierPath *testLine = [UIBezierPath bezierPath];
    for (int i = 0; i < points.count; i++)
    {
        p1 = [[points objectAtIndex:i] CGPointValue];
        [testLine moveToPoint:p1];
        p2 = CGPointMake(p1.x, self.bounds.size.height-4);
        [testLine addLineToPoint:p2];
    }
    CAShapeLayer *testLinePathLayer = [CAShapeLayer layer];
    testLinePathLayer.frame = self.bounds;
    testLinePathLayer.path = testLine.CGPath;
    testLinePathLayer.opacity = self.averageLine.alpha;
    testLinePathLayer.fillColor = nil;
    testLinePathLayer.lineWidth = 1.0;
    
    testLinePathLayer.lineDashPattern = @[@(2),@(2)];
    
    testLinePathLayer.strokeColor = [UIColor yellowColor].CGColor;
    
    if (self.animationTime > 0)
        [self animateForLayer:testLinePathLayer withAnimationType:self.animationType isAnimatingReferenceLine:NO];
    [self.layer addSublayer:testLinePathLayer];
    
    
    
    //----------------------------//
    //----- Draw Fill Colors -----//
    //----------------------------//
    [self.topColor set];
    [fillTop fillWithBlendMode:kCGBlendModeNormal alpha:self.topAlpha];
    
    [self.bottomColor set];
    [fillBottom fillWithBlendMode:kCGBlendModeNormal alpha:self.bottomAlpha];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (self.topGradient != nil) {
        CGContextSaveGState(ctx);
        CGContextAddPath(ctx, [fillTop CGPath]);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, self.topGradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(fillTop.bounds)), 0);
        CGContextRestoreGState(ctx);
    }
    
    if (self.bottomGradient != nil) {
        CGContextSaveGState(ctx);
        CGContextAddPath(ctx, [fillBottom CGPath]);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, self.bottomGradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(fillBottom.bounds)), 0);
        CGContextRestoreGState(ctx);
    }
    
    
    //----------------------------//
    //------ Animate Drawing -----//
    //----------------------------//
    if (self.enableRefrenceLines == YES) {
        CAShapeLayer *verticalReferenceLinesPathLayer = [CAShapeLayer layer];
        verticalReferenceLinesPathLayer.frame = self.bounds;
        verticalReferenceLinesPathLayer.path = verticalReferenceLinesPath.CGPath;
        verticalReferenceLinesPathLayer.opacity = self.lineAlpha == 0 ? 0.1 : self.lineAlpha/2;
        verticalReferenceLinesPathLayer.fillColor = nil;
        verticalReferenceLinesPathLayer.lineWidth = self.lineWidth/2;
        
        if (self.lineDashPatternForReferenceYAxisLines) {
            verticalReferenceLinesPathLayer.lineDashPattern = self.lineDashPatternForReferenceYAxisLines;
        }
        
        if (self.refrenceLineColor) {
            verticalReferenceLinesPathLayer.strokeColor = self.refrenceLineColor.CGColor;
        } else {
            verticalReferenceLinesPathLayer.strokeColor = self.color.CGColor;
        }
        
        if (self.animationTime > 0)
            [self animateForLayer:verticalReferenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
        [self.layer addSublayer:verticalReferenceLinesPathLayer];
        
        
        CAShapeLayer *horizontalReferenceLinesPathLayer = [CAShapeLayer layer];
        horizontalReferenceLinesPathLayer.frame = self.bounds;
        horizontalReferenceLinesPathLayer.path = horizontalReferenceLinesPath.CGPath;
        horizontalReferenceLinesPathLayer.opacity = self.lineAlpha == 0 ? 0.1 : self.lineAlpha/2;
        horizontalReferenceLinesPathLayer.fillColor = nil;
        horizontalReferenceLinesPathLayer.lineWidth = self.lineWidth/2;
        if(self.lineDashPatternForReferenceXAxisLines) {
            horizontalReferenceLinesPathLayer.lineDashPattern = self.lineDashPatternForReferenceXAxisLines;
        }
        
        if (self.refrenceLineColor) {
            horizontalReferenceLinesPathLayer.strokeColor = self.refrenceLineColor.CGColor;
        } else {
            horizontalReferenceLinesPathLayer.strokeColor = self.color.CGColor;
        }
        
        if (self.animationTime > 0)
            [self animateForLayer:horizontalReferenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
        [self.layer addSublayer:horizontalReferenceLinesPathLayer];
    }
    
    CAShapeLayer *referenceLinesPathLayer = [CAShapeLayer layer];
    referenceLinesPathLayer.frame = self.bounds;
    referenceLinesPathLayer.path = referenceFramePath.CGPath;
    referenceLinesPathLayer.opacity = self.lineAlpha == 0 ? 0.1 : self.lineAlpha/2;
    referenceLinesPathLayer.fillColor = nil;
    referenceLinesPathLayer.lineWidth = self.lineWidth/2;
    
    if (self.refrenceLineColor) referenceLinesPathLayer.strokeColor = self.refrenceLineColor.CGColor;
    else referenceLinesPathLayer.strokeColor = self.color.CGColor;
    
    if (self.animationTime > 0)
        [self animateForLayer:referenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
    [self.layer addSublayer:referenceLinesPathLayer];
    
    if (self.disableMainLine == NO) {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.path = line.CGPath;
        pathLayer.strokeColor = self.color.CGColor;
        pathLayer.fillColor = nil;
        pathLayer.opacity = self.lineAlpha;
        pathLayer.lineWidth = self.lineWidth;
        pathLayer.lineJoin = kCALineJoinBevel;
        pathLayer.lineCap = kCALineCapRound;
        if (self.animationTime > 0) [self animateForLayer:pathLayer withAnimationType:self.animationType isAnimatingReferenceLine:NO];
        if (self.lineGradient) [self.layer addSublayer:[self backgroundGradientLayerForLayer:pathLayer]];
        else [self.layer addSublayer:pathLayer];
    }
    
    if (self.averageLine.enableAverageLine == YES) {
        CAShapeLayer *averageLinePathLayer = [CAShapeLayer layer];
        averageLinePathLayer.frame = self.bounds;
        averageLinePathLayer.path = averageLinePath.CGPath;
        averageLinePathLayer.opacity = self.averageLine.alpha;
        averageLinePathLayer.fillColor = nil;
        averageLinePathLayer.lineWidth = self.averageLine.width;
        
        if (self.averageLine.dashPattern) averageLinePathLayer.lineDashPattern = self.averageLine.dashPattern;
        
        if (self.averageLine.color) averageLinePathLayer.strokeColor = self.averageLine.color.CGColor;
        else averageLinePathLayer.strokeColor = self.color.CGColor;
        
        if (self.animationTime > 0)
            [self animateForLayer:averageLinePathLayer withAnimationType:self.animationType isAnimatingReferenceLine:NO];
        [self.layer addSublayer:averageLinePathLayer];
    }
}

- (void)animateForLayer:(CAShapeLayer *)shapeLayer withAnimationType:(BEMLineAnimation)animationType isAnimatingReferenceLine:(BOOL)shouldHalfOpacity {
    if (animationType == BEMLineAnimationNone) return;
    else if (animationType == BEMLineAnimationFade) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        if (shouldHalfOpacity == YES) pathAnimation.toValue = [NSNumber numberWithFloat:self.lineAlpha == 0 ? 0.1 : self.lineAlpha/2];
        else pathAnimation.toValue = [NSNumber numberWithFloat:self.lineAlpha];
        [shapeLayer addAnimation:pathAnimation forKey:@"opacity"];
        
        return;
    } else if (animationType == BEMLineAnimationExpand) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:shapeLayer.lineWidth];
        [shapeLayer addAnimation:pathAnimation forKey:@"lineWidth"];
        
        return;
    } else {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        return;
    }
}

- (CALayer *)backgroundGradientLayerForLayer:(CAShapeLayer *)shapeLayer {
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    CGPoint start, end;
    if (self.lineGradientDirection == BEMLineGradientDirectionHorizontal) {
        start = CGPointMake(0, CGRectGetMidY(shapeLayer.bounds));
        end = CGPointMake(CGRectGetMaxX(shapeLayer.bounds), CGRectGetMidY(shapeLayer.bounds));
    } else {
        start = CGPointMake(CGRectGetMidX(shapeLayer.bounds), 0);
        end = CGPointMake(CGRectGetMidX(shapeLayer.bounds), CGRectGetMaxY(shapeLayer.bounds));
    }
    
    CGContextDrawLinearGradient(imageCtx, self.lineGradient, start, end, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.contents = (id)image.CGImage;
    gradientLayer.mask = shapeLayer;
    return gradientLayer;
}

@end
