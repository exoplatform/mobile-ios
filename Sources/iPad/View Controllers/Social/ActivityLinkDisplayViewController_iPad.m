//
//  ActivityLinkDisplayViewController_iPad.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityLinkDisplayViewController_iPad.h"
#import "defines.h"


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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigation.topItem.title = self.title;
    
    //If the orientation is in Landscape mode
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        CGRect tmpFrame = self.view.frame;
        tmpFrame.size.width += WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT;
        self.view.frame = tmpFrame;
    }
}

- (void)dealloc
{
    [super dealloc];
}

- (void)setHudPosition {
    _hudView.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}



@end
