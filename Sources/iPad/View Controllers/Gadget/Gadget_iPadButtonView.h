//
//  GadgetButton.h
//  HKAF
//
//  Created by Tran Hoai Son on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Gadget_iPad;

//Display gadget as list or grid
@interface Gadget_iPadButtonView: UIView {
	id					_delegate;	//The delegate
	UIButton*			_btnGadget;	//Change gadget view mod
	UILabel*			_lbName;	//Dashboard tab name
	UIImage*			_imgIcon;	//Icon
	NSURL*				_url;	//Gadget tab URL
	Gadget_iPad*		_gadget;	//Gadget info
}

- (id)initWithFrame:(CGRect)rect;	//Constructor
- (void)setDelegate:(id)delegate;	//Set the delegate
- (void)setGadget:(Gadget_iPad*)gadget;	//Set gadget
- (Gadget_iPad*)getGadget;	//Get gadget
- (void)setName:(NSString*)name;	//Set gadget name
- (void)setIcon:(UIImage*)icon;	//Set icon
- (void)setUrl:(NSURL*)url;	//set url
@end
