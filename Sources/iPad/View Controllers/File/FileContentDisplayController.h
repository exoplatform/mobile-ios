//
//  FileContentDisplayController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

//Display file content
@interface FileContentDisplayController : UIViewController <UIWebViewDelegate>
{
	id										_delegate; //The delegate
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//Index of language
	
	IBOutlet UIWebView*						_wvFileContentDisplay;	//File content is displayed on a web view
	IBOutlet UIActivityIndicatorView*		_actiLoading;	//Loading file content
	IBOutlet UILabel*						_lbStatus;	//Loading status
}
@property (nonatomic, retain) UIWebView* _wvFileContentDisplay;
@property (nonatomic, retain) UIActivityIndicatorView* _actiLoading;
@property (nonatomic, retain) UILabel* _lbStatus;

- (void)setDelegate:(id)delegate;	//Set the delegate
- (void)localize;	//Get current language
- (void)startDisplayFileContent:(NSURL*)url;	//View file with its url
@end
