//
//  OptionsViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/30/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

//Create new folder or rename file view controller
@interface OptionsViewController : UIViewController 
{
	IBOutlet UILabel*						_lbInstruction;	//Action title
	IBOutlet UITextField*					_txtfNameInput;	//Input name
	IBOutlet UIButton*						_btnOK;	//Accept button
	IBOutlet UIButton*						_btnCancel;	//Cancel button
	IBOutlet UIActivityIndicatorView*		_indicator;	 //Loading indicator
	id										_delegate;	//The delegate
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//Language index
	BOOL									_isNewFolder;	//Is create new folder
	NSString*								_nameInputStr;	//Given name
	
}

- (void)setIsNewFolder:(BOOL)isNewFolder;	//UI for create new folder
- (void)setNameInputStr:(NSString *)nameStr;	//Give name for text box
- (void)setFocusOnTextFieldName;	//Show keyboard
- (void)setDelegate:(id)delegate;	//Set the delegate
- (void)localize;	//Set language dictionary
- (int)getSelectedLanguage;	//Get current language
- (NSDictionary*)getLocalization;	//Get language dictionary
- (IBAction)onOKBtn:(id)sender;	//Ok
- (IBAction)onCancelBtn:(id)sender;	//Cancel
@end
