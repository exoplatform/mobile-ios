//
//  eXoTapDetectingWindow.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol eXoTapDetectingWindowDelegate
- (void)userDidTapWebView:(id)tapPoint;
@end
@interface eXoTapDetectingWindow : UIWindow {
    UIView *viewToObserve;
    id <eXoTapDetectingWindowDelegate> controllerThatObserves;
    BOOL multipleTouches;
}
@property (nonatomic, retain) UIView *viewToObserve;
@property (nonatomic, assign) id <eXoTapDetectingWindowDelegate> controllerThatObserves;
@end