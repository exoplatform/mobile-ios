//
//  GadgetDisplayViewController_iPad.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import "GadgetDisplayViewController_iPad.h"

@implementation GadgetDisplayViewController_iPad



- (void)setHudPosition {
    _hudGadget.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}



@end
