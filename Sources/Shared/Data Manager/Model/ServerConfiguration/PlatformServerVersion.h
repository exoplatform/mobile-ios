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


@interface PlatformServerVersion : NSObject {
    
    NSString* _platformVersion; // Version of the Platform (3.0 or 3.5 or higher)
    NSString* _platformRevision; // Revision of the Platform
    NSString* _platformBuildNumber; // BuildNumber
    NSString* _isMobileCompliant;
    NSString* _platformEdition;
}


@property (nonatomic, retain) NSString* platformVersion; // Version of the Platform (3.0 or 3.5 or higher)
@property (nonatomic, retain)NSString* platformRevision; // Revision of the Platform
@property (nonatomic, retain)NSString* platformBuildNumber; // BuildNumber

@property (nonatomic, retain)NSString* isMobileCompliant; // 
@property (nonatomic, retain)NSString* platformEdition; //
@property (nonatomic, retain) NSString *currentRepoName;
@property (nonatomic, retain) NSString *defaultWorkSpaceName;
@property (nonatomic, retain) NSString *userHomeNodePath;

@end
