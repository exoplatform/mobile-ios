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


//File, folder infor
@interface File: NSObject
{

	NSString *_path;	//File's jcr url
	BOOL _isFolder;		//Is folder
    NSString *_name;    //name of the file/folder
    BOOL _canAddChild;  //can add new file or folder as it content
    BOOL _canRemove;    //can remove the file/folder
    NSString *_currentFolder;   //the path of file
    NSString *_driveName;   //drive name of file
    BOOL _hasChild;     //if the folder contains any files or folders
    NSString *_workspaceName;   //work space of file
    NSString *_nodeType;    //file content type
    NSString *_creator;     //Name of the one who created the file
    NSDate *_dateCreated;   //the time that the file is created
    NSDate *_dateModified;  //the time that the file is modified
    int _size;              //size of file
    
}

@property(nonatomic, retain) NSString *path;
@property BOOL isFolder;
@property(nonatomic, retain) NSString *name;
@property (readonly, getter=getNaturalName, retain, nonatomic) NSString * naturalName;

@property BOOL canAddChild;
@property BOOL canRemove;
@property(nonatomic, retain) NSString *currentFolder;
@property(nonatomic, retain) NSString *driveName;
@property BOOL hasChild;
@property(nonatomic, retain) NSString *workspaceName;
@property(nonatomic, retain) NSString *nodeType;
@property(nonatomic, retain) NSString *creator;
@property(nonatomic, retain) NSDate *dateCreated;
@property(nonatomic, retain) NSDate *dateModified;
@property int size;

//Tool method to retrive the type of the File
+ (NSString *)fileType:(NSString *)fileName;

-(NSString *) convertToNaturalName;

@end
