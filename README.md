SCPRotatingWheelControl (v1.0) iOS 6.0 +
=======================

Simple customisable control that allows user interaction to spin a wheel and reveal a segment.

Sample project both using storyboards and programmatically included

Pod coming soon.

Installation
--------------
  - Download .zip or add as a submodule
  - Add SCPRotatingWheelControl folder to your Xcode project. This contains the required subclasses. 
    
    (Note all classes are needed)

  - Include ```#import "SCPRotatingWheelControl.h"``` in your controllers .h or .m


Storyboards
--------------
  - Add a empty view to the chosen board for your storyboard
  - Set the custom class of the view to ```SCPRotatingWheelControl```
  - Add a property of that view to your view controller ```@property (weak, nonatomic) IBOutlet SCPRotatingWheelControl *storyBoardRotatingWheelControl;```
  - Set the segment title data and call ```reloadSegment```
```sh
//Set the data and reload the table
[_storyBoardRotatingWheelControl setSegmentTitles:@[@"Segment 1", @"Segment 2"]];
[_storyBoardRotatingWheelControl reloadSegments];
```
  - To listen to the changing of segments set the block property
```
//Set block to handel the call backs with the selected segment index
[_storyBoardRotatingWheelControl setCurrectSegmentDidChangeBlock:^(NSInteger currentSegment) {
    NSLog(@"Current segment %d", currentSegment);
}];
```

Programmatically
----------------
  - Add a property to your view controller ```@property (nonatomic, strong) SCPRotatingWheelControl *codeRotatingWheelControl;```
  - Create a CGSize setting the size you want the wheel to be. 

    (Note width and height must be the same to give a perfect circle)
```
//Set the wheel size
CGSize wheelSize = CGSizeMake(600, 600);
```
  - Init a new instance of ```SCPRotatingWheelControl```
```
//Init a new SCPRotatingWheelControl
self.codeRotatingWheelControl = [[SCPRotatingWheelControl alloc] initWithSize:wheelSize
                                                                segmentTitles:_segmentTitles
                                                           spinOnFirstViewing:YES
                                                               spinCompletion:^(BOOL finished) {
                                                                   //Spinning completed in-case you want to fade on controls once the SCPRotatingWheelControl is ready
                                                                   NSLog(@"Spinning complete");
                                                               }
                                                      currectSegmentDidChange:^(NSInteger currentSegment) {
                                                            //Block to handle the call backs with the selected segment index
                                                            NSLog(@"Current segment %d", currentSegment);
                                                      }];
```
  - The above code handles the change segment events. Set ```spinOnFirstShowing``` to force the wheel to spin the very first time it is shown.
  - Finally set the frame and add it to your view
```
[_codeRotatingWheelControl setFrame:CGRectMake(40, 84, wheelSize.width, wheelSize.height)];
[[self view] addSubview:_codeRotatingWheelControl];
```

Customising the look
-----------------------
  - There are a few methods that you can call on an instance of ```SCPRotatingWheelControl``` that allow you to customise the colour scheme of the wheel easily.
```
[_storyBoardRotatingWheelControl setBottomWheelFillColour:[UIColor colorWithRed:0.384 green:0.565 blue:0.741 alpha:1]];
[_storyBoardRotatingWheelControl setBottomWheelStrokeColour:[UIColor whiteColor]];
[_storyBoardRotatingWheelControl setBottomWheelStrokeWidth:7.0f];

[_storyBoardRotatingWheelControl setTopWheelFillColour:[UIColor colorWithRed:0.463 green:0.698 blue:0.847 alpha:1]];
[_storyBoardRotatingWheelControl setTopWheelStrokeColour:[UIColor whiteColor]];
[_storyBoardRotatingWheelControl setTopWheelStrokeWidth:7.0f];
```
  - If you have several segments (25+) on the wheel you may wish to reduce the viewport of the wheel, making the visable area of the segments narrower. As is the same for a larger view point.
```
[_storyBoardRotatingWheelControl setViewPortSizeOffset:35.0f];
```

(Note you can only have valuse between -35.0f and 35.0f)

Other methods
--------------------
  - If you wish to force the wheel to perform a spin you can do this with the spin method
```
[_storyBoardRotatingWheelControl spinCompletion:^(BOOL finished) {
    NSLog(@"Spinning complete");
}];
```

Future work
--------------------
  - Further customisation of wheel
  - Sounds
  - Any fixes that the open source community finds

License
------------------

MIT
