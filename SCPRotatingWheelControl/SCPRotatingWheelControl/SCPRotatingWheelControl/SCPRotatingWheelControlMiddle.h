//
//  SCPRotatingWheelControlMiddle.h
//  SCPRotatingWheelControl
//
//  Created by Ste Prescott on 05/04/2014.
//  Copyright (c) 2014 Ste Prescott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPRotatingWheelControlBlocks.h"

@import QuartzCore;

@interface SCPRotatingWheelControlMiddle : UIControl

@property (nonatomic, copy) void (^currectSegmentDidChangeBlock)(NSInteger currentSegment);

@property (nonatomic, strong) NSArray *segmentTitles;

@property (nonatomic, strong) UIColor *segmentTextColour;

- (id)initWithSize:(CGSize)size segmentTitles:(NSArray *)segmentTitles currectSegmentDidChange:(CurrectSegmentDidChange)currectSegmentDidChange;

- (void)spinCompletion:(void (^)(BOOL finished))spinCmpletionBlock;
- (void)reloadSegments;

@end
