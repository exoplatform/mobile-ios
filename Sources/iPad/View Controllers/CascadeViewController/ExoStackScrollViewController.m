//
//  ExoStackScrollViewController.m
//  eXo Platform
//
//  Created by exoplatform on 9/10/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "ExoStackScrollViewController.h"
#import "DocumentsViewController.h"
#import "DashboardViewController.h"
#import "ActivityStreamBrowseViewController.h"

#define PANE_NEG_X_POS_MENU_OPENED  130
#define PANE_X_POS_MENU_CLOSED      0

@interface ExoStackScrollViewController ()

@end

@implementation ExoStackScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        activePaneTag = 0;
        startDragPosX = 0;
        leftMenuOpened = NO;
    }
    return self;
}

// Overwrite the method from StackScrollViewController
// Activate scroll to top on the new view controller
// Disable scroll to top on the old view controller
- (void)addViewInSlider:(UIViewController *)controller invokeByController:(UIViewController *)invokeByController isStackStartView:(BOOL)isStackStartView {
    
    [super addViewInSlider:controller invokeByController:invokeByController isStackStartView:isStackStartView];
    
    // Activate the scroll to top gesture on the newly added controller
    if (controller) [self setScrollToTopForViewController:controller withScroll:YES];
    // Disable the scroll to top gesture on the previous controller
    if (invokeByController) [self setScrollToTopForViewController:invokeByController withScroll:NO];
}

// Private method
// Set the property scrollsToTop of the given view controller to YES/NO
// The view controller must be a 
// - ActivityStreamBrowseViewController or
// - DocumentsViewController or
// - DashboardViewController, 
// otherwise the method does nothing
- (void)setScrollToTopForViewController:(UIViewController*)viewC withScroll:(BOOL)scroll {
    if ([viewC isKindOfClass:[ActivityStreamBrowseViewController class]]) {
        [(ActivityStreamBrowseViewController*)viewC tblvActivityStream].scrollsToTop = scroll;
    } else if ([viewC isKindOfClass:[DocumentsViewController class]]) {
        [(DocumentsViewController*)viewC tblFiles].scrollsToTop = scroll;
    } else if ([viewC isKindOfClass:[DashboardViewController class]]) {
        [(DashboardViewController*)viewC tblGadgets].scrollsToTop = scroll;
    }
    // Set the value of the new active pane
    if (scroll) activePaneTag = [viewControllersStack indexOfObject:viewC];
}

// Public method
// Overwrites the method from StackScrollViewController
// Find which pane should respond to the scroll to top gesture
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    // Move the panes as normal
    [super handlePanFrom:recognizer];
    // Saves the start X coordinate of the drag gesture
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startDragPosX = [recognizer locationInView:self.view].x;
    }
    // Only when the panes are in their final position, we update the scrollsToTop property
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // Number of panes moved, usually 1
        NSInteger nbOfPanesMoved = 1;
        // Get the end X coordinate of the drag gesture
        CGFloat endDragPosX = [recognizer locationInView:self.view].x;
        // Measure the length of the drag gesture
        CGFloat dragLength = (endDragPosX-startDragPosX < 0) ? startDragPosX-endDragPosX : endDragPosX-startDragPosX;
        // If the gesture spans more than 1 pane, it's intented to move 2 panes and not only 1
        if (dragLength > (viewAtLeft.frame.size.width)) // 500pts
            nbOfPanesMoved = 2;
        
        if (startDragPosX < endDragPosX) { // Moved right
            if (activePaneTag > 0 ) {
                // Ensure we don't move more panes than there are left to move
                if (activePaneTag < nbOfPanesMoved) nbOfPanesMoved--;
                // Set the scrollsToTop property
                [self setScrollToTopForViewController:[viewControllersStack objectAtIndex:activePaneTag] withScroll:NO];
                [self setScrollToTopForViewController:[viewControllersStack objectAtIndex:activePaneTag-nbOfPanesMoved] withScroll:YES];
            }
            // Check whether the left menu was opened by the gesture
            if (activePaneTag == 0 && viewAtLeft.frame.origin.x == PANE_X_POS_MENU_CLOSED) {
                leftMenuOpened = YES;
            }
        } else if (endDragPosX < startDragPosX) { // Moved left
            if (activePaneTag < viewControllersStack.count-1) {
                // Ensure we don't move more panes than there are left to move
                // If the left menu is opened and the gesture spans less than its size (130pts), close the menu
                // If the left menu is opened and the gesture spans more than its size, close the menu and move 1 pane
                if (activePaneTag+nbOfPanesMoved > viewControllersStack.count-1 ||
                    (leftMenuOpened && dragLength < PANE_NEG_X_POS_MENU_OPENED)) nbOfPanesMoved--;
                // Set the scrollsToTop property
                [self setScrollToTopForViewController:[viewControllersStack objectAtIndex:activePaneTag] withScroll:NO];
                [self setScrollToTopForViewController:[viewControllersStack objectAtIndex:activePaneTag+nbOfPanesMoved] withScroll:YES];
            }
            // Check whether the left menu was closed by the gesture
            if (viewAtLeft.frame.origin.x == -PANE_NEG_X_POS_MENU_OPENED && leftMenuOpened) {
                leftMenuOpened = NO;
                NSLog(@"Menu closed");
            } 
        }
    }
}


// Overwrites the method from StackScrollViewController
// When the device rotates, the left menu is automatically closed
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    leftMenuOpened = NO;
}

@end
