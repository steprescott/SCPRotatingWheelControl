//
//  SCPRotatingWheelControlTop.m
//  SCPRotatingWheelControl
//
//  Created by Ste Prescott on 05/04/2014.
//  Copyright (c) 2014 Ste Prescott. All rights reserved.
//

#import "SCPRotatingWheelControlTop.h"

static CGFloat lowerLimit = -35.0f;
static CGFloat upperLimit = 35.0f;

@implementation SCPRotatingWheelControlTop

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x - 20, frame.origin.y - 20, frame.size.width + 40, frame.size.height + 40)];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:NO];
        
        self.viewPortSizeOffset = 0;
    }
    
    return self;
}

-(void)setViewPortSizeOffset:(CGFloat)viewPortSizeOffset
{
    _viewPortSizeOffset = viewPortSizeOffset;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    //Draw the shape with set styles and size
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor* shadow = [[UIColor blackColor] colorWithAlphaComponent: 0.72f];
    CGSize shadowOffset = CGSizeMake(0.1f, -0.1f);
    CGFloat shadowBlurRadius = 18.5f;
    
    //Validate that the offset does not exceed the limit
    CGFloat viewPortOffsetY = 0.0f;
    
    if(_viewPortSizeOffset < 0.0f)
    {
        if(_viewPortSizeOffset >= lowerLimit)
        {
            viewPortOffsetY = _viewPortSizeOffset;
        }
        else
        {
            viewPortOffsetY = lowerLimit;
            NSLog(@"View port offset can only be bewteen the values of '-35.0' and '35.0'\nView port offset has been set to '-35.0'");
        }
    }
    else
    {
        if(_viewPortSizeOffset <= upperLimit)
        {
            viewPortOffsetY = _viewPortSizeOffset;
        }
        else
        {
            viewPortOffsetY = upperLimit;
            NSLog(@"View port offset can only be bewteen the values of '-35.0' and '35.0'\nView port offset has been set to '35.0'");
        }
    }
    
    //Check if we need ot offset some bezier path points
    CGFloat viewPortOffsetX = 0.0f;
    
    if(viewPortOffsetY != 0.0f)
    {
        viewPortOffsetX = viewPortOffsetY > 0.0f ? (viewPortOffsetY / 5.0f) : ((viewPortOffsetY / 5.0f) - 1.0f);
    }
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(445.82, 93.22)];
    [bezierPath addCurveToPoint: CGPointMake(445.82, 446.78) controlPoint1: CGPointMake(544.73, 190.85) controlPoint2: CGPointMake(544.73, 349.15)];
    [bezierPath addCurveToPoint: CGPointMake(87.66, 446.78) controlPoint1: CGPointMake(346.92, 544.41) controlPoint2: CGPointMake(186.56, 544.41)];
    [bezierPath addCurveToPoint: CGPointMake(20 + viewPortOffsetX, 326.5 + viewPortOffsetY) controlPoint1: CGPointMake(52.87, 412.43) controlPoint2: CGPointMake(30.31, 370.58)];
    [bezierPath addLineToPoint: CGPointMake(235.8, 276.75)];
    [bezierPath addCurveToPoint: CGPointMake(236.17, 262.13) controlPoint1: CGPointMake(234.73, 271.93) controlPoint2: CGPointMake(234.86, 266.9)];
    [bezierPath addLineToPoint: CGPointMake(20.99 + viewPortOffsetX, 209.42 - viewPortOffsetY)];
    [bezierPath addCurveToPoint: CGPointMake(87.66, 93.22) controlPoint1: CGPointMake(31.72, 166.84) controlPoint2: CGPointMake(53.94, 126.51)];
    [bezierPath addCurveToPoint: CGPointMake(445.82, 93.22) controlPoint1: CGPointMake(186.56, -4.41) controlPoint2: CGPointMake(346.92, -4.41)];
    [bezierPath closePath];
    
    //Scale it to what is required
    CGFloat scale = (self.frame.size.width - 40) / 500;
    [bezierPath applyTransform:CGAffineTransformMakeScale(scale, scale)];
    
    //Move it to counteract the scaling
    CGFloat translation = (((scale - 1) * 20) * -1);
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(translation, translation)];
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    _fillColour ? [_fillColour setFill] : [[UIColor lightGrayColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    _strokeColour ? [_strokeColour setStroke] : [[UIColor whiteColor] setStroke];
    bezierPath.lineWidth = _strokeWidth ? _strokeWidth : 7.0f;;
    [bezierPath stroke];
}

@end
