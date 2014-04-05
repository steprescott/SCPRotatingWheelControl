//
//  SCPRotatingWheelControlTop.h
//  SCPRotatingWheelControl
//
//  Created by Ste Prescott on 05/04/2014.
//  Copyright (c) 2014 Ste Prescott. All rights reserved.
//

#import <UIKit/UIKit.h>

@import QuartzCore;

@interface SCPRotatingWheelControlTop : UIView

@property (nonatomic, strong) UIColor *fillColour;
@property (nonatomic, strong) UIColor *strokeColour;
@property (nonatomic, assign) CGFloat strokeWidth;

@property (nonatomic, assign) CGFloat viewPortSizeOffset;

@end
