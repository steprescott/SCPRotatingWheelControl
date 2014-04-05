//
//  SCPRotatingWheelControl.h
//  SCPRotatingWheelControl
//
//  Created by Ste Prescott on 05/04/2014.
//  Copyright (c) 2014 Ste Prescott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPRotatingWheelControlBlocks.h"

@interface SCPRotatingWheelControl : UIView

@property (nonatomic, copy) void (^currectSegmentDidChangeBlock)(NSInteger currentSegment);

@property (nonatomic, strong) NSArray *segmentTitles;

@property (nonatomic, strong) UIColor *bottomWheelFillColour;
@property (nonatomic, strong) UIColor *bottomWheelStrokeColour;
@property (nonatomic, assign) CGFloat bottomWheelStrokeWidth;

@property (nonatomic, strong) UIColor *segmentTextColour;

@property (nonatomic, strong) UIColor *topWheelFillColour;
@property (nonatomic, strong) UIColor *topWheelStrokeColour;
@property (nonatomic, assign) CGFloat topWheelStrokeWidth;

@property (nonatomic, assign) CGFloat viewPortSizeOffset;

/**
 Init method that will generate a FactWheel with block call backs
 */
- (id)initWithSize:(CGSize)size segmentTitles:(NSArray *)segmentTitles spinOnFirstViewing:(BOOL)spinOnFirstViewing spinCompletion:(void (^)(BOOL finished))spinCmpletionBlock currectSegmentDidChange:(CurrectSegmentDidChange)currectSegmentDidChange;

/**
 Will fource a redraw of the segments
 */
- (void)reloadSegments;

- (void)spinCompletion:(void (^)(BOOL finished))spinCmpletionBlock;

@end
