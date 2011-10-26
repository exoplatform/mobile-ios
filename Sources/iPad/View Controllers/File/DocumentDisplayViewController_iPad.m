//
//  DocumentDisplayViewController_iPad.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocumentDisplayViewController_iPad.h"


@implementation DocumentDisplayViewController_iPad


- (void)dealloc
{
    [super dealloc];
}



- (void)setHudPosition {
    _hudDocument.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}

@end
