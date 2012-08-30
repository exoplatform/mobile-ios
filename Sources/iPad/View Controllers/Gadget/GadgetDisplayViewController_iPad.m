//
//  GadgetDisplayViewController_iPad.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import "GadgetDisplayViewController_iPad.h"
#import "defines.h"


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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //Set the title of the controller
    _navigation.topItem.title = _gadget.gadgetName;
}

- (void)updateHudPosition {
    self.hudLoadWaiting.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}


@end
