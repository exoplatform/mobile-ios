//
//  SocialUserProfile.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

//{"id":"e4f574dec0a80126368b5c3e4cc727b4","remoteId":"demo","providerId":"organization","profile":{"avatarUrl":null,"fullName":"Jack Miller"}}
@interface SocialUserProfile : RKObject {
    
    NSString* _identity;
    NSString* _remoteId;
    NSString* _providerId;
    NSString* _avatarUrl;
    NSString* _fullName;
}

@property (nonatomic, retain) NSString* identity;
@property (nonatomic, retain) NSString* remoteId;
@property (nonatomic, retain) NSString* providerId;
@property (nonatomic, retain) NSString* avatarUrl;
@property (nonatomic, retain) NSString* fullName;



@end
