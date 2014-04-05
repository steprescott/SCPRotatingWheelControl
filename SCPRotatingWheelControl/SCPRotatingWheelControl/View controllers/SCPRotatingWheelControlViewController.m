//
//  SCPRotatingWheelControlViewController.m
//  SCPRotatingWheelControl
//
//  Created by Ste Prescott on 05/04/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import "SCPRotatingWheelControlViewController.h"

#import "SCPRotatingWheelControl.h"

typedef NS_ENUM(NSInteger, SetUpMethod) {
    SetUpMethodStoryboard,
    SetUpMethodCode
};

@interface SCPRotatingWheelControlViewController ()

@property (nonatomic, strong) NSMutableArray *segmentTitles;

@property (weak, nonatomic) IBOutlet SCPRotatingWheelControl *storyBoardRotatingWheelControl;
@property (weak, nonatomic) IBOutlet UILabel *storyboardLabel;

@property (nonatomic, strong) SCPRotatingWheelControl *codeRotatingWheelControl;
@property (nonatomic, strong) UILabel *codeLabel;

@property (assign) BOOL shouldSpinWheel;

@end

@implementation SCPRotatingWheelControlViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        //Sample data array
        self.segmentTitles = [@[@"Segment 1",
                               @"Segment 2",
                               @"Segment 3",
                               @"Segment 4",
                               @"Segment 5",
                               @"Segment 6"] mutableCopy];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Determin what setup should be used
    switch ([self.tabBarItem tag])
    {
        case SetUpMethodStoryboard:
        {
            [self setUpStoryboard];
            break;
        }
        case SetUpMethodCode:
        {
            [self setUpCode];
            break;
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Check to see if the wheel has span already
    if(_shouldSpinWheel)
    {
        //Spin the wheel so the user knows that they can spin it
        [self performSelector:@selector(spinWheel) withObject:nil afterDelay:1.0f];
    }
}

- (void)setUpStoryboard
{
    self.shouldSpinWheel = YES;
    
    //Set up design
    [_storyBoardRotatingWheelControl setBottomWheelFillColour:[UIColor colorWithRed:0.384 green:0.565 blue:0.741 alpha:1]];
    [_storyBoardRotatingWheelControl setBottomWheelStrokeColour:[UIColor whiteColor]];
    [_storyBoardRotatingWheelControl setBottomWheelStrokeWidth:7.0f];
    
    [_storyBoardRotatingWheelControl setTopWheelFillColour:[UIColor colorWithRed:0.463 green:0.698 blue:0.847 alpha:1]];
    [_storyBoardRotatingWheelControl setTopWheelStrokeColour:[UIColor whiteColor]];
    [_storyBoardRotatingWheelControl setTopWheelStrokeWidth:7.0f];
    
    //Set the data and reload the table
    [_storyBoardRotatingWheelControl setSegmentTitles:_segmentTitles];
    [_storyBoardRotatingWheelControl reloadSegments];
    
    //Set block to handel the call backs with the selected segment index
    [_storyBoardRotatingWheelControl setCurrectSegmentDidChangeBlock:^(NSInteger currentSegment) {
        NSLog(@"Current segment %d", currentSegment);
        [_storyboardLabel setText:[NSString stringWithFormat:@"Segment index %d", currentSegment]];
    }];
}

- (void)setUpCode
{
    //Set the wheel size
    CGSize wheelSize = CGSizeMake(600, 600);
    
    //Init a new SCPRotatingWheelControl
    self.codeRotatingWheelControl = [[SCPRotatingWheelControl alloc] initWithSize:wheelSize
                                                          segmentTitles:_segmentTitles
                                                     spinOnFirstViewing:YES
                                                         spinCompletion:^(BOOL finished) {
                                                             //Spinning completed incase you want to fade on controls once the SCPRotatingWheelControl is ready
                                                             NSLog(@"Spinning complete");
                                                         }
                                                currectSegmentDidChange:^(NSInteger currentSegment) {
                                                    //Block to handel the call backs with the selected segment index
                                                    NSLog(@"Current segment %d", currentSegment);
                                                    [_codeLabel setText:[NSString stringWithFormat:@"Segment index %d", currentSegment]];
                                                }];
    //Set up design
    [_codeRotatingWheelControl setFrame:CGRectMake(40, 84, wheelSize.width, wheelSize.height)];
    [_codeRotatingWheelControl setBottomWheelFillColour:[UIColor colorWithRed:0.463 green:0.698 blue:0.847 alpha:1]];
    [_codeRotatingWheelControl setBottomWheelStrokeColour:[UIColor whiteColor]];
    [_codeRotatingWheelControl setBottomWheelStrokeWidth:7.0f];
    
    [_codeRotatingWheelControl setTopWheelFillColour:[UIColor colorWithRed:0.384 green:0.565 blue:0.741 alpha:1]];
    [_codeRotatingWheelControl setTopWheelStrokeColour:[UIColor whiteColor]];
    [_codeRotatingWheelControl setTopWheelStrokeWidth:7.0f];
    
    [[self view] addSubview:_codeRotatingWheelControl];
    
    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(760, 215, 340, 65)];
    [_codeLabel setBackgroundColor:[UIColor clearColor]];
    [_codeLabel setTextColor:[UIColor whiteColor]];
    [_codeLabel setFont:[UIFont systemFontOfSize:20]];
    [_codeLabel setText:@"Segment index 0"];
    [[self view] addSubview:_codeLabel];
    
    UIButton *addSegmentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addSegmentButton setFrame:CGRectMake(663, 321, 340, 41)];
    [addSegmentButton setTitle:@"Add segment" forState:UIControlStateNormal];
    [[addSegmentButton titleLabel] setFont:[UIFont systemFontOfSize:20]];
    [addSegmentButton setTintColor:[UIColor colorWithRed:0.478 green:0.843 blue:0.992 alpha:1]];
    [addSegmentButton addTarget:self action:@selector(addSegmentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:addSegmentButton];
    
    UIButton *removeSegmentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [removeSegmentButton setFrame:CGRectMake(664, 385, 340, 41)];
    [removeSegmentButton setTitle:@"Remove segment" forState:UIControlStateNormal];
    [[removeSegmentButton titleLabel] setFont:[UIFont systemFontOfSize:20]];
    [removeSegmentButton setTintColor:[UIColor colorWithRed:0.478 green:0.843 blue:0.992 alpha:1]];
    [removeSegmentButton addTarget:self action:@selector(removeSegmentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:removeSegmentButton];
    
    UILabel *viewPortSizeOffsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(748, 462, 340, 65)];
    [viewPortSizeOffsetLabel setBackgroundColor:[UIColor clearColor]];
    [viewPortSizeOffsetLabel setTextColor:[UIColor whiteColor]];
    [viewPortSizeOffsetLabel setFont:[UIFont systemFontOfSize:20]];
    [viewPortSizeOffsetLabel setText:@"Viewport size offset"];
    [[self view] addSubview:viewPortSizeOffsetLabel];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(659, 507, 348, 65)];
    [slider setMinimumValue:-35.0f];
    [slider setMaximumValue:35.0f];
    [slider setValue:0.0f];
    [slider addTarget:self action:@selector(viewpointSliderDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:slider];
}

//Independent method so it can be called with delay
- (void)spinWheel
{
    self.shouldSpinWheel = NO;
    [_storyBoardRotatingWheelControl spinCompletion:^(BOOL finished) {
        NSLog(@"Spinning complete");
    }];
}

//Adds a new title to the array and then reloads the segments
- (IBAction)addSegmentButtonPressed:(id)sender
{
    [_segmentTitles addObject:[NSString stringWithFormat:@"Segment %d", [_segmentTitles count] + 1]];
    [_storyBoardRotatingWheelControl reloadSegments];
    [_codeRotatingWheelControl reloadSegments];
}

//Removes the last object of the titles array and then reloads the segments
- (IBAction)removeSegmentButtonPressed:(id)sender
{
    [_segmentTitles removeObject:[_segmentTitles lastObject]];
    [_storyBoardRotatingWheelControl reloadSegments];
    [_codeRotatingWheelControl reloadSegments];
}

//Method to demonstrate the view port size
- (IBAction)viewpointSliderDidChangeValue:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [_storyBoardRotatingWheelControl setViewPortSizeOffset:[slider value]];
    [_codeRotatingWheelControl setViewPortSizeOffset:[slider value]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
