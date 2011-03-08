//
//  GadgetButton.h
//  HKAF
//
//  Created by Tran Hoai Son on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Gadget_iPad;

@interface GadgetButtonView_iPad: UIView {
	id					_delegate;
	UIButton*			_btnGadget;
	UILabel*			_lbName;
	UIImage*			_imgIcon;
	NSURL*				_url;
	Gadget_iPad*		_gadget;
}

- (id)initWithFrame:(CGRect)rect;
- (void)setDelegate:(id)delegate;
- (void)setGadget:(Gadget_iPad*)gadget;
- (Gadget_iPad*)getGadget;
- (void)setName:(NSString*)name;
- (void)setIcon:(UIImage*)icon;
- (void)setUrl:(NSURL*)url;
@end
