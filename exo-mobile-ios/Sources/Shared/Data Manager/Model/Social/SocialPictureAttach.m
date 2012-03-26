//
//  SocialPictureAttach.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialPictureAttach.h"


@implementation SocialPictureAttach

@synthesize docPath = _docPath;
@synthesize message = _message;
@synthesize docLink = _docLink;
@synthesize workspace = _workspace;
@synthesize repository = _repository;
@synthesize docName = _docName;

- (NSString *)description
{
    return [NSString stringWithFormat:@"-%@, %@, %@, %@",_docPath?_docPath:@"",_message?_message:@"",_docLink?_docLink:@"", _workspace?_workspace:@"",_repository?_repository:@"",_docName?_docName:@""];
}

@end
