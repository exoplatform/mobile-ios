//
//  ActivityLinkDisplayViewController_iPad.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityLinkDisplayViewController_iPad.h"


@implementation ActivityLinkDisplayViewController_iPad


- (void)dealloc
{
    [_navBar release];
    _navBar = nil;
    
    [super dealloc];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    _navBar.topItem.title = self.titleForActivityLink;
}

- (void) setTitle:(NSString *)title {
    _navBar.topItem.title = self.titleForActivityLink;
}


- (void)setHudPosition {
    _hudDocument.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}

@end
