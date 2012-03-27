//
//  GadgetDisplayController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Gadget;

@interface GadgetDisplayController : UIViewController <UIWebViewDelegate>
{
	id										_delegate;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
	IBOutlet UINavigationBar*				_nvTitle;
	IBOutlet UIWebView*						_wvGadgetDisplay;
	IBOutlet UIActivityIndicatorView*		_actiLoading;	
	IBOutlet UILabel*						_lbStatus;
	IBOutlet UIButton*						_btnLeftEdgeNavigation;
	IBOutlet UIButton*						_btnRightEdgeNavigation;
}
@property (nonatomic, retain) UIWebView* _wvGadgetDisplay;
@property (nonatomic, retain) UIActivityIndicatorView* _actiLoading;
@property (nonatomic, retain) UILabel* _lbStatus;
@property (nonatomic, retain) UIButton* _btnLeftEdgeNavigation;
@property (nonatomic, retain) UIButton* _btnRightEdgeNavigation;


//- (id)initWithNibAndUrl:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)defaultURL;
- (void)setDelegate:(id)delegate;
- (void)localize;
//- (void)startGadget:(NSURL*)gadgetUrl;
- (void)startGadget:(Gadget*)gadget;
@end
