//
//  OptionsViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/30/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OptionsViewController : UIViewController 
{
	IBOutlet UILabel*						_lbInstruction;
	IBOutlet UITextField*					_txtfNameInput;
	IBOutlet UIButton*						_btnOK;
	IBOutlet UIButton*						_btnCancel;	
	IBOutlet UIActivityIndicatorView*		_indicator;
	id										_delegate;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
}

- (void)setFocusOnTextFieldName;
- (void)setDelegate:(id)delegate;
- (void)localize;
- (int)getSelectedLanguage;
- (NSDictionary*)getLocalization;
- (IBAction)onOKBtn:(id)sender;
- (IBAction)onCancelBtn:(id)sender;
@end
