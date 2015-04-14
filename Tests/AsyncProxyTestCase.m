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


#import "AsyncProxyTestCase.h"
#import <OHHTTPStubs.h>

@implementation AsyncProxyTestCase

- (void)setUp
{
    [super setUp];
    // Set up a RestKit shared manager that is used in some proxies
    NSString* strBaseUrl = [NSString stringWithFormat:@"%@/rest/", TEST_SERVER_URL];
    RKObjectManager* manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:strBaseUrl]];
    [RKObjectManager setSharedManager:manager];
}

- (void)tearDown
{
    [OHHTTPStubs removeAllStubs];
    // Removes the RK shared manager
    [RKObjectManager setSharedManager:nil];
    [super tearDown];
}

- (void)wait
{
    // Wait for the asynchronous code to finish, or a 2s timeout
    NSDate* timeoutDate = [NSDate dateWithTimeIntervalSinceNow:2];
    responseArrived = NO;
    while (!responseArrived && ([timeoutDate timeIntervalSinceNow]>0))
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, YES);
}

#pragma Proxy delegate methods

- (void)restKitDidLoadObjects:(NSArray *)objects
{

}

- (void)restKitDidFailWithError:(NSError *)error
{

}

- (void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    responseArrived = YES;
}

- (void)proxyDidFinishLoading:(SocialProxy *)proxy
{
    responseArrived = YES;
}

- (void)loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error
{
    responseArrived = YES;
}

- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    responseArrived = YES;
}

@end
