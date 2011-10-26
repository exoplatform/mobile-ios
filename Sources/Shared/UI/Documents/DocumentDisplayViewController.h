//
//  DocumentDisplayViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "eXoViewController.h"

@interface DocumentDisplayViewController : eXoViewController <UIWebViewDelegate> {
    
    UIWebView*	_webView;	//Display gadget on webview
	NSURL* _url;	//document URL
    NSString *_fileName;
    
    //Loader
    ATMHud*                 _hudDocument;//Heads up display
}

@property (nonatomic, retain) IBOutlet NSURL* _url;
@property (nonatomic, retain) IBOutlet UIWebView* _webView;

- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL fileName:(NSString *)fileName;
- (void)setUrl:(NSURL*)url;	//Set gadget URL

- (void)setHudPosition;

@end
