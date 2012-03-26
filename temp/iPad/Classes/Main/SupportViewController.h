//
//  SupportViewController.h
//  iTradeDirect
//
//  Created by Tran Hoai Son on 4/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SupportViewController : UIViewController {
	id						_delegate;
	int						_selectedLanguage;
	NSDictionary*			_dictLocalize;
	UIWebView*				_wvHelp;
}
@property (nonatomic, retain) id	_delegate;
@property (nonatomic, retain) NSDictionary*	_dictLocalize;

- (void)setDelegate:(id)delegate;
- (void)localize;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (IBAction)close:(id)sender;
@end
