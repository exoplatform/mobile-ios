//
//  SupportViewController.h
//  iTradeDirect
//
//  Created by Tran Hoai Son on 4/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

//User guide view controller
@interface SupportViewController : UIViewController {
	id						_delegate;	//The delegate
	int						_selectedLanguage;	//Language index
	NSDictionary*			_dictLocalize;	//Language dictionary
	UIWebView*				_wvHelp;	//Display help content
}
@property (nonatomic, retain) id	_delegate;
@property (nonatomic, retain) NSDictionary*	_dictLocalize;

- (void)setDelegate:(id)delegate;	//Set delegate
- (void)localize;	//Set language dictionary
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;	//Change orientation
- (IBAction)close:(id)sender;	//Close view
@end
