//
//  GadgetDisplayController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Gadget_iPad;

//Display gadget
@interface GadgetDisplayController : UIViewController <UIWebViewDelegate>
{
	id										_delegate;	//The delegate
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//language index
	IBOutlet UINavigationBar*				_nvTitle;	//Navigation bar
	IBOutlet UIWebView*						_wvGadgetDisplay;	//display gaget on webview
	IBOutlet UIActivityIndicatorView*		_actiLoading;	//Loading indicator
	IBOutlet UILabel*						_lbStatus;	//Loading label
	IBOutlet UIButton*						_btnLeftEdgeNavigation;	//Left image for navigation bar
	IBOutlet UIButton*						_btnRightEdgeNavigation;	//Right image for navigation bar
	NSString*								_strBConnectStatus;	//Loading text
}
@property (nonatomic, retain) UIWebView* _wvGadgetDisplay;
@property (nonatomic, retain) UIActivityIndicatorView* _actiLoading;
@property (nonatomic, retain) UILabel* _lbStatus;
@property (nonatomic, retain) UIButton* _btnLeftEdgeNavigation;
@property (nonatomic, retain) UIButton* _btnRightEdgeNavigation;


- (void)setDelegate:(id)delegate; //Set delegate
- (void)localize;	//Get current language
- (void)startGadget:(Gadget_iPad*)gadget; //Display gadget
@end
