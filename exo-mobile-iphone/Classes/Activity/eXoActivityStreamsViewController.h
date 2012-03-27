//
//  eXoActivityStreamsViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/8/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface eXoActivityStreamsViewController : UIViewController <UIWebViewDelegate>{
	UIWebView*	_webView;
	UILabel*	_statusLabel;
	//UIActivityIndicatorView* _progressIndicator;
	NSURL* _url;	
}

@property (nonatomic, retain) NSURL* _url;
@property (nonatomic, retain) UIWebView* _webView;
@property (nonatomic, retain) UILabel* _statusLabel;
//@property (nonatomic, retain) UIActivityIndicatorView* _progressIndicator;

- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL;
@end

//@class XMPPClient;
//
//@interface eXoActivityStreamsViewController : UIViewController <UIWebViewDelegate> {
//	XMPPClient* xmppClient;
//}
//@end
