//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//


#import "SocialTestsHelper.h"
#import "ActivityHelper.h"

@implementation SocialTestsHelper

+ (SocialTestsHelper*)getInstance
{
    static SocialTestsHelper *instance;
    @synchronized(self)
    {
        if (!instance)
        {
            instance = [[SocialTestsHelper alloc] init];
        }
        return instance;
    }
    return instance;
}

- (SocialRestConfiguration *)createSocialRestConfiguration
{
    SocialRestConfiguration *conf = [SocialRestConfiguration sharedInstance];
    conf.restContextName = kRestContextName;
    conf.restVersion = kRestVersion;
    conf.portalContainerName = kPortalContainerName;
    conf.username = TEST_USER_NAME;
    conf.password = TEST_USER_PASS;
    
    return conf;
}

- (void)clearSocialRestConfiguration
{
    SocialRestConfiguration *conf = [SocialRestConfiguration sharedInstance];
    conf.restContextName = @"";
    conf.restVersion = @"";
    conf.portalContainerName = @"";
    conf.username = @"";
    conf.password = @"";
}


- (SocialUserProfile *)createSocialUserProfile
{
    SocialUserProfile *profile = [[SocialUserProfile alloc] init];
    profile.identity = @"e4f574dec0a80126368b5c3e4cc727b4";
    profile.remoteId = TEST_USER_NAME;
    profile.providerId = @"organization";
    profile.fullName = [NSString stringWithFormat:@"%@ %@", TEST_USER_FIRST_NAME, TEST_USER_LAST_NAME];
    profile.avatarUrl = @"http://demo.platform.exo.org/rest/jcr/repository/social/organization/profile/johndoe/avatar/?upd=1378196459997";
    return profile;
}

- (SocialUserProfile *)createSocialUserProfileWithID:(NSString *)pid username:(NSString *)uname fullname:(NSString *)fname
{
    SocialUserProfile *profile = [[SocialUserProfile alloc] init];
    profile.identity = pid;
    profile.remoteId = uname;
    profile.providerId = @"organization";
    profile.fullName = fname;
    profile.avatarUrl = @"http://demo.platform.exo.org/rest/jcr/repository/social/organization/profile/johndoe/avatar/?upd=1378196459997";
    return profile;
}

- (SocialActivity *)createSocialActivity
{
    SocialActivity *act = [[SocialActivity alloc] init];
    act.activityId = @"1e20cf09c06313bc0a9d372ecd6bd2a7";
    act.identityId = @"d3c28a300a2106c658573c3c030bf9da";
    act.postedTime = 1400664805123;
    act.lastUpdated = 1400664805123;
    act.liked = NO;
    act.title = @"A cool activity";
    act.body = @"";
    act.activityType = ACTIVITY_LINK;
    return act;
}

- (SocialComment *)createCommentWithID:(NSString *)cid text:(NSString *)text
{
    SocialComment *comm = [[SocialComment alloc] init];
    comm.identityId = cid;
    comm.text = text;
    
    return comm;
}

@end
