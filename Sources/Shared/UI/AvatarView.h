//
//  AvatarView.h
//  eXo Platform
//
//  Created by exoplatform on 5/31/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "EGOImageView.h"

@class SocialUserProfile;

@interface AvatarView : EGOImageView

@property (nonatomic, retain) SocialUserProfile *userProfile;

@end
