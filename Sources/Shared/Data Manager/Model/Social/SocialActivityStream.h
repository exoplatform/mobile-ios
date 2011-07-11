//
//  SocialActivityStream.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface SocialActivityStream : RKObject {
    NSString*           _identityId;
    NSString*           _totalNumberOfComments;
    NSString*           _liked;
    NSString*           _postedTime;
    NSString*           _title;
    NSString*           _createdAt;
}

@property (nonatomic, retain) NSString* _identityId;
@property (nonatomic, retain) NSString* _totalNumberOfComments;
@property (nonatomic, retain) NSString* _liked;
@property (nonatomic, retain) NSString* _postedTime;
@property (nonatomic, retain) NSString* _title;
@property (nonatomic, retain) NSString* _createdAt;


@end
