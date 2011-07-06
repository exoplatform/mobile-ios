//
//  GadgetDisplayViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/13/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class eXoApplicationsViewController;
@class Gadget_iPhone;

//Display gadget content
@interface GadgetDisplayViewController : UIViewController <UIWebViewDelegate>{
	UIWebView*	_webView;	//Display gadget on webview
	UILabel*	_statusLabel;	//Loading label
	UIActivityIndicatorView* _progressIndicator;	//Loading indicator
	NSURL* _url;	//Gadget URL
	int			_selectedLanguage;	//Current language index
	NSDictionary*	_dictLocalize;	//Language dictionary
	eXoApplicationsViewController *_delegate;	//main app view controller
	NSString*	_strBConnectStatus;	//Network connection status
}

@property (nonatomic, retain) IBOutlet NSURL* _url;
@property (nonatomic, retain) IBOutlet UIWebView* _webView;
@property (nonatomic, retain) IBOutlet UILabel* _statusLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _progressIndicator;
@property (nonatomic, retain) eXoApplicationsViewController *_delegate;

- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL;	//Constructor
- (void)startGadget:(Gadget_iPhone*)gadget;	//Display gadget
- (void)setUrl:(NSURL*)url;	//Set gadget URL
@end

