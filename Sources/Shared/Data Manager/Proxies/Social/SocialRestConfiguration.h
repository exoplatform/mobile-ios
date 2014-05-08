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

#import <Foundation/Foundation.h>

#define kRestVersion [NSString stringWithFormat:@"v1-alpha3"]
#define kRestContextName [NSString stringWithFormat:@"rest"]
#define kPortalContainerName [NSString stringWithFormat:@"portal"]


@interface SocialRestConfiguration : NSObject {
    
    NSString* _domainName;
    NSString* _portalContainerName;
    NSString* _restContextName;
    NSString* _restVersion;
    NSString* _username;
    NSString* _password;
    
}


@property (copy, nonatomic) NSString* domainName;
@property (copy, nonatomic) NSString* portalContainerName;
@property (copy, nonatomic) NSString* restContextName;
@property (copy, nonatomic) NSString* restVersion;
@property (copy, nonatomic) NSString* username;
@property (copy, nonatomic) NSString* password;



+ (SocialRestConfiguration*)sharedInstance;
- (void)updateDatas; //Method can be used to update datas after authentication
- (NSString *)createBaseUrl;


@end
