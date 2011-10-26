//
//  GadgetDisplayViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "eXoViewController.h"
@class Gadget;

//Display gadget content
@interface GadgetDisplayViewController : eXoViewController <UIWebViewDelegate> {
	UIWebView*	_webView;	//Display gadget on webview
	NSURL* _url;	//Gadget URL
	NSString*	_strBConnectStatus;	//Network connection status
    
    //Loader
    ATMHud*                 _hudGadget;//Heads up display
}

@property (nonatomic, retain) IBOutlet NSURL* _url;
@property (nonatomic, retain) IBOutlet UIWebView* _webView;

- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL;	//Constructor
- (void)setUrl:(NSURL*)url;	//Set gadget URL

- (void)setHudPosition;

@end

