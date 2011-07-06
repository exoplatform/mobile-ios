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
	NSString *_fileName;	//File name
	NSString *_urlStr;	//File URL
	NSString *_contentType;	//File content type
	BOOL _isFolder;		//Is folder
}

@property(nonatomic, retain) NSString *fileName;
@property(nonatomic, retain) NSString *urlStr;
@property(nonatomic, retain) NSString *contentType;
@property BOOL isFolder;

//Tool method to retrive the type of the File
+ (NSString *)fileType:(NSString *)fileName;


//Constructor
-(id)initWithUrlStr:(NSString *)urlStr fileName:(NSString *)fileName;



@end
