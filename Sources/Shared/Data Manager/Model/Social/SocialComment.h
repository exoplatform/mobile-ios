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
#import <RestKit/RestKit.h>
#import "SocialIdentity.h"
#import "SocialUserProfile.h"

/*
 {
 "text": "ouais un comment",
 "identityId": "e4f574dec0a80126368b5c3e4cc727b4",
 "createdAt": "Fri Jul 15 14:48:18 +0200 2011",
 "postedTime": 1310734098154
 }
 */

@interface SocialComment : NSObject{
    
    NSString*           _text;
    NSString*           _identityId;
    NSString*           _createdAt;
    double              _postedTime;
    NSString*           _postedTimeInWords;
    
    SocialUserProfile*  _userProfile;
    
}

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSMutableArray * linkURLs;
@property (nonatomic, retain) NSMutableArray * imageURLs;


@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* identityId;
@property (nonatomic, retain) NSString* createdAt;
@property double postedTime;
@property (nonatomic, retain) NSString* postedTimeInWords;
@property (nonatomic, retain) SocialUserProfile* userProfile;

- (void)convertToPostedTimeInWords;
- (void)convertHTMLEncoding;
- (void)parseHTML;
- (NSString *) toHTML;

@end
