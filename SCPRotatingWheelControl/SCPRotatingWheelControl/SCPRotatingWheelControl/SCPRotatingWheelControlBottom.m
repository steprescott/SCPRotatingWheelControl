//
//  SCPRotatingWheelControlBottom.m
//  SCPRotatingWheelControl
//
//  Created by Ste Prescott on 05/04/2014.
//  Copyright (c) 2014 Ste Prescott. All rights reserved.
//

#import "SCPRotatingWheelControlBottom.h"

@implementation SCPRotatingWheelControlBottom

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x - 20, frame.origin.y - 20, frame.size.width + 40, frame.size.height + 40)];
    
    if (self)
    {
        //Clear the background and don't stop the touch events passing thorugh
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:NO];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //Draw the shape with set styles and size
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* shadow = [[UIColor blackColor] colorWithAlphaComponent: 0.72f];
    CGSize shadowOffset = CGSizeMake(0.1f, -0.1f);
    CGFloat shadowBlurRadius = 18.5f;

    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height - 40)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    _fillColour ? [_fillColour setFill] : [[UIColor darkGrayColor] setFill];
    [ovalPath fill];
    CGContextRestoreGState(context);
    
    _strokeColour ? [_strokeColour setStroke] : [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = _strokeWidth ? _strokeWidth : 7.0f;
    [ovalPath stroke];
}

@end
