//
//  SCPRotatingWheelControlSector.m
//  SCPRotatingWheelControl
//
//  Created by Ste Prescott on 05/04/2014.
//  Copyright (c) 2014 Ste Prescott. All rights reserved.
//

#import "SCPRotatingWheelControlSegment.h"

@implementation SCPRotatingWheelControlSegment

- (NSString *) description
{
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.segmentNumber, self.minValue, self.midValue, self.maxValue];
}

@end
