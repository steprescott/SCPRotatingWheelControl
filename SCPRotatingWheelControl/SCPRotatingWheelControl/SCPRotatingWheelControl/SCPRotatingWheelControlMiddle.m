//
//  SCPRotatingWheelControlMiddle.m
//  SCPRotatingWheelControl
//
//  Created by Ste Prescott on 05/04/2014.
//  Copyright (c) 2014 Ste Prescott. All rights reserved.
//

#import "SCPRotatingWheelControlMiddle.h"
#import "SCPRotatingWheelControlSegment.h"
#import "SCPRotatingWheelControlBottom.h"

@interface SCPRotatingWheelControlMiddle ()

@property (nonatomic, strong) UIView *container;

@property NSInteger numberOfSegments;
@property (nonatomic, strong) NSMutableArray *segments;
@property NSInteger currentSegment;

@property CGAffineTransform startTransform;

@end

static CGFloat deltaAngle;

@implementation SCPRotatingWheelControlMiddle

- (id)initWithSize:(CGSize)size segmentTitles:(NSArray *)segmentTitles currectSegmentDidChange:(CurrectSegmentDidChange)currectSegmentDidChange
{
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    if ((self = [super initWithFrame:frame]))
    {
        self.currectSegmentDidChangeBlock = currectSegmentDidChange;
        self.currentSegment = 0;
        self.segmentTitles = segmentTitles;
        self.numberOfSegments = [segmentTitles count];
        
        if(frame.size.width != frame.size.height)
        {
            NSLog(@"Frame for SCPRotatingWheelControl needs to have the same width and height");
            return nil;
        }
        
        [self drawWheel];
	}
    
    return self;
}

- (void)setSegmentTitles:(NSArray *)segmentTitles
{
    //Set the segment title array but also update the numberOfSegments to match the number of segment titles. Reset current segment
    _segmentTitles = segmentTitles;
    self.numberOfSegments = [_segmentTitles count];
    self.currentSegment = 0;
}

- (void)reloadSegments
{
    [self drawWheel];
}

- (void)drawWheel
{
    [[_container subviews] enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [subview removeFromSuperview];
    }];
    
    self.container = [[UIView alloc] initWithFrame:self.frame];
    
    CGFloat angleSize = 2 * M_PI / _numberOfSegments;
  
    for (NSInteger i = 0; i < _numberOfSegments; i++)
    {
        UILabel *segmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width / 2), 40)];
        [segmentLabel setBackgroundColor:[UIColor clearColor]];
        [segmentLabel setText:[NSString stringWithFormat:@"   %@", _segmentTitles[i]]];
        [segmentLabel setTextColor:_segmentTextColour ? _segmentTextColour : [UIColor whiteColor]];
        [segmentLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [[segmentLabel layer] setAnchorPoint:CGPointMake(1.0f, 0.5f)];
        
        [[segmentLabel layer] setPosition:CGPointMake(_container.bounds.size.width/2.0, _container.bounds.size.height/2.0)];
        [segmentLabel setTransform:CGAffineTransformMakeRotation(angleSize * i)];
        [segmentLabel setTag:i];
        
        [_container addSubview:segmentLabel];
    }
   
    [_container setUserInteractionEnabled:NO];
    [self addSubview:_container];
    
    self.segments = [NSMutableArray arrayWithCapacity:_numberOfSegments];
    
    //Mod to build correct segment
    if (_numberOfSegments % 2 == 0)
    {
        [self buildsegmentsEven];
    }
    else
    {
        [self buildsegmentsOdd];
    }
    
    if(_currectSegmentDidChangeBlock)
    {
        _currectSegmentDidChangeBlock(_currentSegment);
    }
}

- (void)spinCompletion:(void (^)(BOOL finished))spinCmpletionBlock
{
    //Animate the wheel to show that it can be spined
    
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [_container setTransform:CGAffineTransformRotate([_container transform], -M_PI)];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0f
                                          animations:^{
                                              [_container setTransform:CGAffineTransformRotate([_container transform], M_PI)];
                                          } completion:^(BOOL finished) {
                                              if(spinCmpletionBlock)
                                              {
                                                  spinCmpletionBlock(YES);
                                              }
                                          }];
                     }];
}

- (float)calculateDistanceFromCenter:(CGPoint)point
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx * dx + dy * dy);
}

- (void)buildsegmentsOdd
{
    //Define segment length
    CGFloat fanWidth = M_PI * 2 / _numberOfSegments;
    
    //Set initial midpoint value
    CGFloat midPoint = 0;
    
    //Iterate through all segments
    for (NSInteger i = 0; i < _numberOfSegments; i++)
    {
        //Create a segment and set its values
        SCPRotatingWheelControlSegment *segment = [[SCPRotatingWheelControlSegment alloc] init];
        [segment setMidValue:midPoint];
        [segment setMinValue:midPoint - (fanWidth/2)];
        [segment setMaxValue:midPoint + (fanWidth/2)];
        [segment setSegmentNumber:i];
        
        midPoint -= fanWidth;
        
        if ([segment minValue] < - M_PI)
        {
            midPoint = -midPoint;
            midPoint -= fanWidth;
        }
        
        //Add segment to array
        [_segments addObject:segment];
    }
}

- (void)buildsegmentsEven
{
    CGFloat fanWidth = M_PI * 2 / _numberOfSegments;
    CGFloat midPoint = 0;
    
    //Iterate through all segments
    for (NSInteger i = 0; i < _numberOfSegments; i++)
    {
        //Create a segment and set its values
        SCPRotatingWheelControlSegment *segment = [[SCPRotatingWheelControlSegment alloc] init];
        [segment setMidValue:midPoint];
        [segment setMinValue:midPoint - (fanWidth/2)];
        [segment setMaxValue:midPoint + (fanWidth/2)];
        [segment setSegmentNumber:i];
        
        if (([segment maxValue] - fanWidth) < - M_PI)
        {
            midPoint = M_PI;
            [segment setMidValue:midPoint];
            [segment setMinValue:fabsf(segment.maxValue)];
        }
        
        midPoint -= fanWidth;
        
        //Add segment to array
        [_segments addObject:segment];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Get touch position
    CGPoint touchPoint = [touch locationInView:self];
    
    //Calculate the distance between the center of the container view and the touch point
    CGFloat distance = [self calculateDistanceFromCenter:touchPoint];
    
    //If the distance from the center is within 60 points of the center or past the bounds of the wheel ignore the tap event
    if (distance < 60 || distance > (self.frame.size.width - 20))
    {
        NSLog(@"Ignoring tap (%f, %f) because it is too close to the center or beyond the bounds of the SCPRotatingWheelControl view", touchPoint.x, touchPoint.y);
        return NO;
    }
    
    //Get the y and x distance values
    float dx = touchPoint.x - _container.center.x;
    float dy = touchPoint.y - _container.center.y;
    
    //Calculate arctangent value
    deltaAngle = atan2(dy,dx);
    
    //Save current transform
    self.startTransform = _container.transform;
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    //Keep updating the transform as the user drags their finger
    CGPoint pt = [touch locationInView:self];
    
    float dx = pt.x  - _container.center.x;
    float dy = pt.y  - _container.center.y;
    
    float ang = atan2(dy,dx);
    float angleDifference = deltaAngle - ang;
    
    [_container setTransform:CGAffineTransformRotate(_startTransform, -angleDifference)];

    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    if([_segments count] == _numberOfSegments)
    {
        //Get current container rotation in radians
        CGFloat radians = atan2f(_container.transform.b, _container.transform.a);
        
        //Initialize new value giving it access to be used inside a block
        __block CGFloat newVal = 0.0;
        
        //Iterate through all the segments
        [_segments enumerateObjectsUsingBlock:^(SCPRotatingWheelControlSegment *segment, NSUInteger idx, BOOL *stop) {
            
            //See if the current sector contains the radian value
            if ([segment minValue] > 0 && [segment maxValue] < 0)
            {
                //Check for anomaly (occurs with even number of sectors)
                if ([segment maxValue] > radians || [segment minValue] < radians)
                {
                    //Find the quadrant (positive or negative)
                    if (radians > 0)
                    {
                        newVal = radians - M_PI;
                    }
                    else
                    {
                        newVal = M_PI + radians;
                    }
                    
                    self.currentSegment = [segment segmentNumber];
                }
            }
            else if (radians > [segment minValue] && radians < [segment maxValue])
            {
                //All non-anomalous cases
                newVal = radians - [segment midValue];
                self.currentSegment = [segment segmentNumber];
            }
        }];
        
        //Animate the wheel to snap to current segment
        [UIView animateWithDuration:0.2
                         animations:^{
                             [_container setTransform:CGAffineTransformRotate(_container.transform, -newVal)];
                         }];

        //Call the block if possible
        if(_currectSegmentDidChangeBlock)
        {
            _currectSegmentDidChangeBlock(_currentSegment);
        }
    }
}

- (void)setSegmentTextColour:(UIColor *)segmentTextColour
{
    _segmentTextColour = segmentTextColour;
    
    [[_container subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[UILabel class]])
        {
            UILabel *lable = (UILabel *)obj;
            [lable setTextColor:_segmentTextColour];
        }
    }];
}

@end
