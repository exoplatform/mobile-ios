//
//  GadgetButton.h
//  HKAF
//
//  Created by Tran Hoai Son on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GadgetButton_iPhone : UIView {
	id					_delegate;
	UIButton*			_btnGadget;
	UILabel*			_lbName;
	UIImage*			_imgIcon;
	NSURL*				_url;
}

- (id)initWithFrame:(CGRect)rect;
- (void)setDelegate:(id)delegate;
- (void)setName:(NSString*)name;
- (void)setIcon:(UIImage*)icon;
- (void)setUrl:(NSURL*)url;
@end
