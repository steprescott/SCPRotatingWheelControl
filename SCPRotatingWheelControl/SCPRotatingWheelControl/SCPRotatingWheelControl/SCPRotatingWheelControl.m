//
//  SCPRotatingWheelControl.m
//  SCPRotatingWheelControl
//
//  Created by Ste Prescott on 05/04/2014.
//  Copyright (c) 2014 Ste Prescott. All rights reserved.
//

#import "SCPRotatingWheelControl.h"

#import "SCPRotatingWheelControlBottom.h"
#import "SCPRotatingWheelControlMiddle.h"
#import "SCPRotatingWheelControlTop.h"

@interface SCPRotatingWheelControl ()

@property (nonatomic, strong) SCPRotatingWheelControlBottom *rotatingWheelControlBottom;
@property (nonatomic, strong) SCPRotatingWheelControlMiddle *rotatingWheelControlMiddle;
@property (nonatomic, strong) SCPRotatingWheelControlTop *totatingWheelControlTop;

@end

@implementation SCPRotatingWheelControl

//Storyboard init
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    //Simple check. Needs to be the same to be a perfect circle
    if(frame.size.width != frame.size.height)
    {
        NSLog(@"The width of the fact wheel must be equal to the height.\n    Error : '[[SCPRotatingWheelControl alloc] initWithSize:CGSizeMake(%f, %f)'\nShould be : '[[SCPRotatingWheelControl alloc] initWithSize:CGSizeMake(%f, %f)'\n       Or : '[[SCPRotatingWheelControl alloc] initWithSize:CGSizeMake(%f, %f)'", frame.size.width, frame.size.height, frame.size.width, frame.size.width, frame.size.height, frame.size.height);
        return self;
    }

    if (self)
    {
        self.segmentTitles = nil;
        
        //Set up the correct views
        self.rotatingWheelControlBottom = [[SCPRotatingWheelControlBottom alloc] initWithFrame:frame];
        self.totatingWheelControlTop = [[SCPRotatingWheelControlTop alloc] initWithFrame:frame];
        self.rotatingWheelControlMiddle = [[SCPRotatingWheelControlMiddle alloc] initWithSize:self.frame.size
                                                          segmentTitles:_segmentTitles
                                                currectSegmentDidChange:nil];
        
        //Add them in the correct order
        [self addSubview:_rotatingWheelControlBottom];
        [self addSubview:_rotatingWheelControlMiddle];
        [self addSubview:_totatingWheelControlTop];
    }
    
    return self;
}

//Code init
- (id)initWithSize:(CGSize)size segmentTitles:(NSArray *)segmentTitles spinOnFirstViewing:(BOOL)spinOnFirstViewing spinCompletion:(void (^)(BOOL finished))spinCmpletionBlock currectSegmentDidChange:(CurrectSegmentDidChange)currectSegmentDidChange
{
    //Simple check. Needs to be the same to be a perfect circle
    if(size.width != size.height)
    {
        NSLog(@"The width of the fact wheel must be equal to the height.\n    Error : '[[SCPRotatingWheelControl alloc] initWithSize:CGSizeMake(%f, %f)'\nShould be : '[[SCPRotatingWheelControl alloc] initWithSize:CGSizeMake(%f, %f)'\n       Or : '[[SCPRotatingWheelControl alloc] initWithSize:CGSizeMake(%f, %f)'", size.width, size.height, size.width, size.width, size.height, size.height);
        return nil;
    }
    
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    if (self)
    {
        self.segmentTitles = segmentTitles;
        
        //Set up the correct views but this time with passed blocks
        self.rotatingWheelControlBottom = [[SCPRotatingWheelControlBottom alloc] initWithFrame:self.frame];
        self.totatingWheelControlTop = [[SCPRotatingWheelControlTop alloc] initWithFrame:self.frame];
        self.rotatingWheelControlMiddle = [[SCPRotatingWheelControlMiddle alloc] initWithSize:self.frame.size
                                                          segmentTitles:_segmentTitles
                                                currectSegmentDidChange:^(NSInteger currentSegment) {
                                                    if(currectSegmentDidChange)
                                                    {
                                                        currectSegmentDidChange(currentSegment);
                                                    }
                                                }];
        
        //Ensure that the frames are in the center of this view
        [_rotatingWheelControlBottom setCenter:self.center];
        [_rotatingWheelControlMiddle setCenter:self.center];
        [_totatingWheelControlTop setCenter:self.center];
        
        //Add them in the correct order
        [self addSubview:_rotatingWheelControlBottom];
        [self addSubview:_rotatingWheelControlMiddle];
        [self addSubview:_totatingWheelControlTop];
        
        //BOOL to offer spinning on the first load or not
        if(spinOnFirstViewing)
        {
            [_rotatingWheelControlMiddle spinCompletion:spinCmpletionBlock];
        }
        else
        {
            if(spinCmpletionBlock)
            {
                spinCmpletionBlock(YES);
            }
        }
    }
    
    return self;
}

- (void)reloadSegments
{
    //Fade out the necessary views
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [_rotatingWheelControlMiddle setAlpha:0.0f];
                     } completion:^(BOOL finished) {
                         //Once the wheel is faded out remove it and then reload the segments
                         [_rotatingWheelControlMiddle removeFromSuperview];
                         [_rotatingWheelControlMiddle setSegmentTitles:_segmentTitles];
                         [_rotatingWheelControlMiddle reloadSegments];
                         
                         //Ensure the views are in the correct order
                         [self sendSubviewToBack:_rotatingWheelControlBottom];
                         [self addSubview:_rotatingWheelControlMiddle];
                         [self bringSubviewToFront:_totatingWheelControlTop];
                         
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              //Fade the segments on
                                              [_rotatingWheelControlMiddle setAlpha:1.0f];
                                          }];
                     }];
    
}

//Setters that update subviews
- (void)setSegmentTitles:(NSArray *)segmentTitles
{
    _segmentTitles = segmentTitles;
    [_rotatingWheelControlMiddle setSegmentTitles:_segmentTitles];
}

- (void)spinCompletion:(void (^)(BOOL finished))spinCmpletionBlock
{
    [_rotatingWheelControlMiddle spinCompletion:spinCmpletionBlock];
}

- (void)setCurrectSegmentDidChangeBlock:(void (^)(NSInteger))currectSegmentDidChangeBlock
{
    _currectSegmentDidChangeBlock = currectSegmentDidChangeBlock;
    [_rotatingWheelControlMiddle setCurrectSegmentDidChangeBlock:_currectSegmentDidChangeBlock];
}

- (void)setBottomWheelFillColour:(UIColor *)bottomWheelFillColour
{
    _bottomWheelFillColour = bottomWheelFillColour;
    [_rotatingWheelControlBottom setFillColour:_bottomWheelFillColour];
}

- (void)setBottomWheelStrokeColour:(UIColor *)bottomWheelStrokeColour
{
    _bottomWheelStrokeColour = bottomWheelStrokeColour;
    [_rotatingWheelControlBottom setStrokeColour:_bottomWheelStrokeColour];
}

- (void)setBottomWheelStrokeWidth:(CGFloat)bottomWheelStrokeWidth
{
    _bottomWheelStrokeWidth = bottomWheelStrokeWidth;
    [_rotatingWheelControlBottom setStrokeWidth:_bottomWheelStrokeWidth];
}

- (void)setSegmentTextColour:(UIColor *)segmentTextColour
{
    _segmentTextColour = segmentTextColour;
    [_rotatingWheelControlMiddle setSegmentTextColour:_segmentTextColour];
}

- (void)setTopWheelFillColour:(UIColor *)topWheelFillColour
{
    _topWheelFillColour = topWheelFillColour;
    [_totatingWheelControlTop setFillColour:_topWheelFillColour];
}

- (void)setTopWheelStrokeColour:(UIColor *)topWheelStrokeColour
{
    _topWheelStrokeColour = topWheelStrokeColour;
    [_totatingWheelControlTop setStrokeColour:_topWheelStrokeColour];
}

- (void)setTopWheelStrokeWidth:(CGFloat)topWheelStrokeWidth
{
    _topWheelStrokeWidth = topWheelStrokeWidth;
    [_totatingWheelControlTop setStrokeWidth:_topWheelStrokeWidth];
}

- (void)setViewPortSizeOffset:(CGFloat)viewPortSizeOffset
{
    _viewPortSizeOffset = viewPortSizeOffset;
    [_totatingWheelControlTop setViewPortSizeOffset:_viewPortSizeOffset];
}

@end
