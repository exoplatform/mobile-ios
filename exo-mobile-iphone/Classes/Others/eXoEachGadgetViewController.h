//
//  eXoEachGadgetViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/18/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface eXoEachGadgetViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate> {
	UIWebView*			_webvGadgetView;
	UIView*				_vwBrowserSupperView;
	CGRect				_rectBrowserViewOriginalFrame;
	
	NSString*			_url;
	IBOutlet UIImageView*		_imgvGadgetIcon;
	IBOutlet UIButton*			_imgBtn;
}

@property (readwrite, retain) NSString* _url;
+ (id)instance;
+ (id)newInstance;
- (void)setUrl:(NSString*)urlStr;
- (void)setGadgetIcon:(UIImage*)image;
@end
