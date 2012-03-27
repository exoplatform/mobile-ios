//
//  FileContentDisplayController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileContentDisplayController : UIViewController <UIWebViewDelegate>
{
	id										_delegate;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
	
	IBOutlet UIWebView*						_wvFileContentDisplay;
	IBOutlet UIActivityIndicatorView*		_actiLoading;	
	IBOutlet UILabel*						_lbStatus;
}
@property (nonatomic, retain) UIWebView* _wvFileContentDisplay;
@property (nonatomic, retain) UIActivityIndicatorView* _actiLoading;
@property (nonatomic, retain) UILabel* _lbStatus;

//- (id)initWithNibAndUrl:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)defaultURL;
- (void)setDelegate:(id)delegate;
- (void)localize;
- (void)startDisplayFileContent:(NSURL*)url;
@end
