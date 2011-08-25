//
//  GadgetDisplayViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Gadget;

//Display gadget content
@interface GadgetDisplayViewController : UIViewController <UIWebViewDelegate> {
	UIWebView*	_webView;	//Display gadget on webview
	UILabel*	_statusLabel;	//Loading label
	UIActivityIndicatorView* _progressIndicator;	//Loading indicator
	NSURL* _url;	//Gadget URL
	NSString*	_strBConnectStatus;	//Network connection status
}

@property (nonatomic, retain) IBOutlet NSURL* _url;
@property (nonatomic, retain) IBOutlet UIWebView* _webView;
@property (nonatomic, retain) IBOutlet UILabel* _statusLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _progressIndicator;

- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL;	//Constructor
- (void)setUrl:(NSURL*)url;	//Set gadget URL

@end

