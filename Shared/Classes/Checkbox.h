//
//  Checkbox.h
//  RestaurantMng
//
//  Created by Tran Hoai Son on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Remeber & Autologin check box
@interface Checkbox : UIButton {
	id			_delegate;	//Main app view controller
	BOOL		_bTouched;	//Is touched
}

//Instructor
- (id)initWithFrame:(CGRect)rect andState:(BOOL)bTouch;
//Gettors & settors
- (void)setDelegate:(id)delegate;
- (void)setStatus:(BOOL)status;
- (BOOL)getStatus;
@end
