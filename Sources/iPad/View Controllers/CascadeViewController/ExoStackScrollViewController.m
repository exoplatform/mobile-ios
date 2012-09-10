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

@interface ExoStackScrollViewController ()

@end

@implementation ExoStackScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)addViewInSlider:(UIViewController *)controller invokeByController:(UIViewController *)invokeByController isStackStartView:(BOOL)isStackStartView {
    
    // Activate the scroll to top gesture on the newly added controller
    if (controller) [self setScrollToTopForViewController:controller withScroll:YES];
    // Disable the scroll to top gesture on the previous controller
    if (invokeByController) [self setScrollToTopForViewController:invokeByController withScroll:NO];
    
    [super addViewInSlider:controller invokeByController:invokeByController isStackStartView:isStackStartView];
    
}

- (void)setScrollToTopForViewController:(UIViewController*)viewC withScroll:(BOOL)scroll {
    if ([viewC isKindOfClass:[ActivityStreamBrowseViewController class]])
        [(ActivityStreamBrowseViewController*)viewC tblvActivityStream].scrollsToTop = scroll;
    else if ([viewC isKindOfClass:[DocumentsViewController class]])
        [(DocumentsViewController*)viewC tblFiles].scrollsToTop = scroll;
    else if ([viewC isKindOfClass:[DashboardViewController class]])
        [(DashboardViewController*)viewC tblGadgets].scrollsToTop = scroll;
}

@end
