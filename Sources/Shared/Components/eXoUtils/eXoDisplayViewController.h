//
//  eXoDisplayViewController.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eXoViewController.h"
#import "LanguageHelper.h"
#import "eXoFullScreenView.h"

@interface eXoDisplayViewController : eXoViewController<UIWebViewDelegate, UIScrollViewDelegate>
{
    BOOL fullscreen;
    UIWebView*	_webView;	
	NSURL* _url;
    NSString *_fileName;
    CGRect rect;
    UINavigationController *navigationBar;
    //eXoFullScreenView *viewController;
}

@property (nonatomic, retain) IBOutlet UIWebView* _webView;

- (void)setUrl:(NSURL*)url;	//Set gadget URL

@end
