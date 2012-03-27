//
//  eXoWebViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/13/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class eXoApplicationsViewController;

@interface eXoWebViewController : UIViewController <UIWebViewDelegate>{
	UIWebView*	_webView;
	UILabel*	_statusLabel;
	UIActivityIndicatorView* _progressIndicator;
	NSURL* _url;	
	int			_selectedLanguage;
	NSDictionary*	_dictLocalize;
	eXoApplicationsViewController *_delegate;
}

@property (nonatomic, retain) IBOutlet NSURL* _url;
@property (nonatomic, retain) IBOutlet UIWebView* _webView;
@property (nonatomic, retain) IBOutlet UILabel* _statusLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _progressIndicator;
@property (nonatomic, retain) eXoApplicationsViewController *_delegate;

- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL;

@end

