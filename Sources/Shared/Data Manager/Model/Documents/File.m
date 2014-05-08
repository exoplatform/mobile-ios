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

#import "File.h"
#import "FilesProxy.h"
#import "AuthenticateProxy.h"

@implementation File

@synthesize path=_path, isFolder=_isFolder;
@synthesize name=_name, canAddChild=_canAddChild, canRemove=_canRemove, currentFolder=_currentFolder, 
driveName=_driveName, hasChild=_hasChild, workspaceName=_workspaceName, nodeType=_nodeType,
creator=_creator, dateCreated=_dateCreated, dateModified=_dateModified, size=_size;


+ (NSString *)fileType:(NSString *)type
{	
    NSString* strIconFileName = @"unknownFileIcon.png";
    if (type != nil || type.length > 0) {
        if (([type rangeOfString:@"image"]).length > 0)
            strIconFileName = @"DocumentIconForImage.png";
        else if (([type rangeOfString:@"video"]).length > 0)
            strIconFileName = @"DocumentIconForVideo.png";
        else if (([type rangeOfString:@"audio"]).length > 0)
            strIconFileName = @"DocumentIconForMusic.png";
        else if (([type rangeOfString:@"application/msword"]).length > 0)
            strIconFileName = @"DocumentIconForWord.png";
        else if (([type rangeOfString:@"application/pdf"]).length > 0)
            strIconFileName = @"DocumentIconForPdf.png";
        else if (([type rangeOfString:@"application/xls"]).length > 0)
            strIconFileName = @"DocumentIconForXls.png";
        else if (([type rangeOfString:@"application/vnd.ms-powerpoint"]).length > 0)
            strIconFileName = @"DocumentIconForPpt.png";
        else if (([type rangeOfString:@"text"]).length > 0)
            strIconFileName = @"DocumentIconForTxt.png";
    } else
        strIconFileName = @"unknownFileIcon.png";
    
    return strIconFileName;

}


-(NSString *)convertPathToUrlStr:(NSString *)path
{
	return [path stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
}


- (void)dealloc {
    
    [_path release];
    [_name release];
    [_currentFolder release];
    [_driveName release];
    [_workspaceName release];
    [_nodeType release];
    [_creator release];
    [_dateCreated release];
    [_dateModified release];
    [super dealloc];
}


@end
