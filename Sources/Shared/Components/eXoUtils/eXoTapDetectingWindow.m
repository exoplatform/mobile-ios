//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "eXoTapDetectingWindow.h"

@implementation eXoTapDetectingWindow

@synthesize viewToObserve;
@synthesize controllerThatObserves;
@synthesize multipleTouches;

- (instancetype)initWithViewToObserver:(UIView *)view andDelegate:(id<eXoTapDetectingWindowDelegate>)delegate {
    if(self == [super init]) {
        self.viewToObserve = view;
        self.controllerThatObserves = delegate;
    }
    return self;
}

- (void)dealloc {
    self.viewToObserve = nil;
    self.controllerThatObserves = nil;
    self.multipleTouches = nil;
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
        self.multipleTouches = YES;

}
- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (self.viewToObserve == nil || self.controllerThatObserves == nil)
        return;
    
    NSSet *touches = [event allTouches];
    if (touches.count != 1)
        return;
    
    if (self.multipleTouches)
        return;
    
    LogDebug(@"%ld",(long)touches.count);
    UITouch *touch = touches.anyObject;
    if (touch.phase != UITouchPhaseEnded)
        return;
    
    if ([touch.view isDescendantOfView:self.viewToObserve] == NO)
        return;
    
    CGPoint tapPoint = [touch locationInView:self.viewToObserve];
    NSArray *pointArray = @[[NSString stringWithFormat:@"%f", tapPoint.x],
                           [NSString stringWithFormat:@"%f", tapPoint.y]];

    if (touch.tapCount == 1) {
        [self performSelector:@selector(forwardTap:) withObject:pointArray afterDelay:0.1];
    }
    else if (touch.tapCount > 1) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forwardTap:) object:pointArray];
    }
}


@end
