//
//  eXoUser.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/11/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoUser.h"


@implementation eXoUser

@synthesize _userId, _screenName, _profileImageUrl;

- (void) dealloc 
{
	[_userId release];
	[_screenName release];
	[_profileImageUrl release];
    [super dealloc];
}
@end
