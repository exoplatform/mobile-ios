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

//{"id":"e4f574dec0a80126368b5c3e4cc727b4","remoteId":"demo","providerId":"organization","profile":{"avatarUrl":null,"fullName":"Jack Miller"}}
@interface SocialUserProfile : NSObject {
    
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
