//
//  ActivityLinkDisplayViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMHud.h"
#import "ATMHudDelegate.h"


@interface ActivityLinkDisplayViewController : UIViewController <UIWebViewDelegate> {
    
    UIWebView*	_webView;	//Display gadget on webview
	NSURL* _url;	//document URL
    
    //Loader
    ATMHud*                 _hudDocument;//Heads up display
}

@property (nonatomic, retain) IBOutlet NSURL* _url;
@property (nonatomic, retain) IBOutlet UIWebView* _webView;

- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL;
- (void)setUrl:(NSURL*)url;	//Set URL

- (void)setHudPosition;

@end
