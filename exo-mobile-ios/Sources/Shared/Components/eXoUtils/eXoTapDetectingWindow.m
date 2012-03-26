//
//  eXoTapDetectingWindow.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoTapDetectingWindow.h"

@implementation eXoTapDetectingWindow

@synthesize viewToObserve;
@synthesize controllerThatObserves;
- (id)initWithViewToObserver:(UIView *)view andDelegate:(id<eXoTapDetectingWindowDelegate>)delegate {
    if(self == [super init]) {
        self.viewToObserve = view;
        self.controllerThatObserves = delegate;
    }
    return self;
}
- (void)dealloc {
    [viewToObserve release];
    controllerThatObserves = nil;
    [super dealloc];
}
- (void)forwardTap:(id)touch {
    [controllerThatObserves userDidTapWebView:touch];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    // cancel any pending handleSingleTap messages 
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forwardTap) object:nil];
    
    // update our touch state
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;

}
- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (viewToObserve == nil || controllerThatObserves == nil)
        return;
    NSSet *touches = [event allTouches];
    if (touches.count != 1)
        return;
    
    if (multipleTouches)
        return;
    
    NSLog(@"%d",touches.count);
    UITouch *touch = touches.anyObject;
    if (touch.phase != UITouchPhaseEnded)
        return;
    if ([touch.view isDescendantOfView:viewToObserve] == NO)
        return;
    CGPoint tapPoint = [touch locationInView:viewToObserve];
    //NSLog(@"TapPoint = %f, %f", tapPoint.x, tapPoint.y);
    NSArray *pointArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", tapPoint.x],
                           [NSString stringWithFormat:@"%f", tapPoint.y], nil];

    if (touch.tapCount == 1) {
        [self performSelector:@selector(forwardTap:) withObject:pointArray afterDelay:0.1];
    }
    else if (touch.tapCount > 1) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forwardTap:) object:pointArray];
    }
}


@end
