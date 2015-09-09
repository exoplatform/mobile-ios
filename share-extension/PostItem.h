//
// Copyright (C) 2003-2015 eXo Platform SAS.
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
#import <UIKit/UIKit.h>
@interface PostItem : NSObject <UIWebViewDelegate>
enum {
    eXoItemStatusReadyToUpload = 0,
    eXoItemStatusUploadSuccess = 1,
    eXoItemStatusUploadFailed = -1,
    eXoItemStatusUploadFileTooLarge = -2,
};

@property (nonatomic, retain) NSData * fileData;
@property (nonatomic, retain) NSString * fileExtension;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSURL * url; // could be URL in LINK Activity, FileURL or NSData for Post File Activity
@property (nonatomic, retain) NSString * pageWebTitle; // in LINK Activty
@property (nonatomic, retain) NSString * imageURLFromLink;

@property (nonatomic) int uploadStatus;
@property (nonatomic) int isImageItem;
// After upload
@property (nonatomic, retain) NSString * fileUploadedURL;
@property (nonatomic, retain) NSString * fileUploadedName;

-(id) init;

-(NSString *) generateUploadFileName ;

#pragma mark - link activity
-(void) searchForImageInURL;

@end
