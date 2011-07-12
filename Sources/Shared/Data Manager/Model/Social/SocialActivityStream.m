//
//  SocialActivityStream.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityStream.h"


@implementation SocialActivityStream

@synthesize _identityId;
@synthesize _totalNumberOfComments;
@synthesize _liked;
@synthesize _postedTime;
@synthesize _title;
@synthesize _createdAt;


+ (NSDictionary*)elementToPropertyMappings {
    //for test
	return [NSDictionary dictionaryWithObjectsAndKeys:nil];
            //@"_identityId",@"identityId",nil];
}


- (void)dealloc {
    [_identityId release];
    [_totalNumberOfComments release];
    [_liked release];
    [_postedTime release];
    [_title release];
    [_createdAt release];
    [super dealloc];
}

@end
