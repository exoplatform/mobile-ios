//
//  Checkbox.h
//  RestaurantMng
//
//  Created by Tran Hoai Son on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Checkbox : UIButton {
	id			_delegate;
	BOOL		_bTouched;
}

- (id)initWithFrame:(CGRect)rect andState:(BOOL)bTouch;
- (void)setDelegate:(id)delegate;
- (void)setStatus:(BOOL)status;
- (BOOL)getStatus;
@end
