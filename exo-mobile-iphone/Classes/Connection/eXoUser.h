//
//  eXoUser.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/11/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface eXoUser : NSObject {
	@private
	NSString*	_userId;
	NSString*	_screenName;
	NSString*	_profileImageUrl;
}
@property (readwrite, copy) NSString* _userId;
@property (readwrite, copy) NSString* _screenName;
@property (readwrite, copy) NSString* _profileImageUrl;
@end
