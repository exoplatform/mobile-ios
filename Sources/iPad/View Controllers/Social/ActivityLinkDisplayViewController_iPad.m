//
//  ActivityLinkDisplayViewController_iPad.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityLinkDisplayViewController_iPad.h"

#define WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT 250



@implementation ActivityLinkDisplayViewController_iPad

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
        //If the orientation is in Landscape mode
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            CGRect tmpFrame = self.view.frame;
            tmpFrame.size.width += WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT;
            self.view.frame = tmpFrame;
        }
    }
    return self;
}



- (void)dealloc
{
    [super dealloc];
}

- (void)setHudPosition {
    _hudDocument.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}



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
