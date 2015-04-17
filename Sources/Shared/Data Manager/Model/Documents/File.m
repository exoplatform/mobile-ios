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
@synthesize name=_name, naturalName= _naturalName, canAddChild=_canAddChild, canRemove=_canRemove, currentFolder=_currentFolder,
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
    [_naturalName release];
    _naturalName = nil;
    [super dealloc];
}

/*!
 @return the title of the folder/file
 */
-(NSString *) getNaturalName{

    if (_naturalName!=nil) {
        // sometime the name of the folder/file is created automatically the the system. In this case we use the converted name as the title of the folder
        return _naturalName;
    }
    return _name;
}


/*!
 Folders in the "Group" section are named automatically by the system & these names are not really nice.
 The goal of this method is to convert this name into a more natural one without special characters.
 */
-(NSString* ) convertToNaturalName {
    
    NSMutableString * s = [_name mutableCopy];
    [s replaceOccurrencesOfString:@"." withString:@" " options:NSLiteralSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"_" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"-" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@" exo" withString:@" eXo" options:NSLiteralSearch range:NSMakeRange(0,s.length)];
    
    while ([s rangeOfString:@"  "].location !=NSNotFound) {
        [s replaceOccurrencesOfString:@"  " withString:@" " options:NSLiteralSearch range:NSMakeRange(0,s.length)];
    }
    
    while ([s characterAtIndex:0] == ' ') {
        [s deleteCharactersInRange:NSMakeRange(0,1)];
    }
    while ([s characterAtIndex:(s.length-1)] == ' ') {
        [s deleteCharactersInRange:NSMakeRange(s.length-1,1)];
    }
    [s replaceCharactersInRange:NSMakeRange(0,1) withString:[[s substringWithRange:NSMakeRange(0,1)] uppercaseString]];
    
    //First character of a word would be in Uppercase
    for (int index =1; index < s.length -1 ; index++ ){
        if ([s characterAtIndex:index] == ' ' ){
            [s replaceCharactersInRange:NSMakeRange(index+1,1) withString:[[s substringWithRange:NSMakeRange(index+1,1)] uppercaseString]];
        }
    }
   [s replaceOccurrencesOfString:@"EXo" withString:@"eXo" options:NSLiteralSearch range:NSMakeRange(0,s.length)];

    if (_naturalName) {
        [_naturalName release];
    }
    if ([s rangeOfString:@"Spaces"].location == 0){
        _naturalName = [s substringFromIndex:[s rangeOfString:@"Spaces"].length+1];
    } else {
        _naturalName = [s substringFromIndex:0];
    }
    [_naturalName retain];
    return _naturalName;
}

@end
