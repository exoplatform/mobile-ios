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
#import "AuthenticateProxy.h"
#import "File.h"

//--------------------------------------
//-        Actions Definition          -
//--------------------------------------

#define kFileProtocolForDelete @"DELETE"
#define kFileProtocolForUpload @"UPLOAD"
#define kFileProtocolForCopy @"COPY"
#define kFileProtocolForMove @"MOVE"
#define kFileProtocolForCreateFolder @"MKCOL"


@interface FilesProxy : NSObject {    

    BOOL _isWorkingWithMultipeUserLevel;
    NSString *_strUserRepository;

}

@property BOOL _isWorkingWithMultipeUserLevel;
@property(nonatomic, retain) NSString *_strUserRepository;

+ (FilesProxy *)sharedInstance;
+ (NSString*)stringEncodedWithBase64:(NSString*)str;
+ (NSString *)urlForFileAction:(NSString *)url;

- (void)calculateAbsPath:(NSString *)relativePath forItem:(File *)item;
- (NSArray*)getDrives:(NSString*)driveName;
- (NSArray*)getContentOfFolder:(File *)file;

//Create user's repository home url
- (void)creatUserRepositoryHomeUrl;

//Use this method to do some actions over files (DELETE, PUT, COPY, PASTE...)
//Return en error Message
-(NSString *)fileAction:(NSString *)protocol source:(NSString *)source destination:(NSString *)destination data:(NSData *)data;

-(BOOL)createNewFolderWithURL:(NSString *)strUrl folderName:(NSString *)name;
-(BOOL)isExistedUrl:(NSString *)strUrl;

@end
