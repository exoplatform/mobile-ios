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


#import "ServerManagerHelper.h"

@implementation ServerManagerHelper

@synthesize manager;

+ (ServerManagerHelper*)getInstance
{
    static ServerManagerHelper *instance;
    @synchronized(self)
    {
        if (!instance)
        {
            instance = [[ServerManagerHelper alloc] init];
            instance.manager = [ApplicationPreferencesManager sharedInstance];
        }
        return instance;
    }
    return instance;
}

- (void) addDefaultAccount
{
    [self.manager addEditServerWithServerName:TEST_SERVER_NAME
                  andServerUrl:TEST_SERVER_URL
                  withUsername:TEST_USER_NAME
                  andPassword:TEST_USER_PASS
                  atIndex:-1];
}

- (void) addNAccounts:(int)n
{
    for (int i=1; i<=n; i++) {
        ServerObj* accN = [[ServerObj alloc] init];
        accN._strServerName = [NSString stringWithFormat:@"%@ %d", TEST_SERVER_NAME, i];
        accN._strServerUrl = TEST_SERVER_URL;
        accN.username = [NSString stringWithFormat:@"%@_%d", TEST_USER_NAME, i];
        accN.password = TEST_USER_PASS;
        [self addAccount:accN];
    }
}

- (void) addAccount:(ServerObj *)account
{
    [self.manager addEditServerWithServerName:account._strServerName
                  andServerUrl:account._strServerUrl
                  withUsername:account.username
                  andPassword:account.password
                  atIndex:-1];
}

- (void) deleteAccount:(ServerObj *)account
{
    
}

- (void) deleteAllAccounts
{
    if ([self.manager serverList] != nil) {
        for (int i=0; i<[[self.manager serverList] count]; i++) {
            [self.manager deleteServerObjAtIndex:i];
        }
    }

}

@end
