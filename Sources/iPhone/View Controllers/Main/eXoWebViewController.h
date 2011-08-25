//
//  eXoWebViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/13/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>

//View file or gadget
@interface eXoWebViewController : UIViewController <UIWebViewDelegate>{
	UIWebView*	_webView;	//Display file, gadget
	UILabel*	_statusLabel;	//Loding label
	UIActivityIndicatorView* _progressIndicator;	//Loading indicator
	NSURL* _url;	//File, gadget URL
    NSString* _fileName; //Name of the file to display
}

@property (nonatomic, retain) IBOutlet NSURL* _url;
@property (nonatomic, retain) IBOutlet UIWebView* _webView;
@property (nonatomic, retain) IBOutlet UILabel* _statusLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* _progressIndicator;

//Constructors
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL;
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL fileName:(NSString *)fileName;


@end

