//
//  File.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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


@end
