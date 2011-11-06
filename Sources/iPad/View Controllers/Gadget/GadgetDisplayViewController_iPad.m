//
//  GadgetDisplayViewController_iPad.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import "GadgetDisplayViewController_iPad.h"

#define WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT 250


@implementation GadgetDisplayViewController_iPad

- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle gadget:(GadgetItem *)gadgetToLoad {
    if ((self = [super initWithNibAndUrl:nibName bundle:nibBundle gadget:gadgetToLoad])) {
        
        //If the orientation is in Landscape mode
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            CGRect tmpFrame = self.view.frame;
            tmpFrame.size.width += WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT;
            self.view.frame = tmpFrame;
        }
    }
    return  self;
}

- (void)setHudPosition {
    _hudGadget.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}


//Test for rotation management
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) { 
        CGRect tmpRect = self.view.frame;
        tmpRect.size.width += WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT;
        tmpRect.origin.x -= WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT;
        self.view.frame = tmpRect;
    } else {
        CGRect tmpRect = self.view.frame;
        tmpRect.size.width -= WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT;
        tmpRect.origin.x += WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT;
        self.view.frame = tmpRect;
    }
}


@end
