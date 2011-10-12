//
//  SocialPictureAttach.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SocialPictureAttach : NSObject {
    NSString*           _docPath;
    NSString*           _message;
    NSString*           _docLink;
    NSString*           _workspace;
    NSString*           _repository;
    NSString*           _docName;
    
}
@property (nonatomic, retain) NSString*           docPath;
@property (nonatomic, retain) NSString*           message;
@property (nonatomic, retain) NSString*           docLink;
@property (nonatomic, retain) NSString*           workspace;
@property (nonatomic, retain) NSString*           repository;
@property (nonatomic, retain) NSString*           docName;


@end
