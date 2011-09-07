//
//  FileFolderActionsViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 01/09/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileActionsViewController.h"

@class File;


@protocol FileFolderActionsProtocol 
//Method needed to call to create a new folder
-(void)createNewFolder:(NSString *)newFolderName;

//Method needed to rename a folder
-(void)renameFolder:(NSString *)newFolderName;

//Method needed when the Controller must be hidden
-(void)cancelFolderActions;

@end


@interface FileFolderActionsViewController :  UIViewController 
{
	IBOutlet UILabel*						_lbInstruction;	//Action title
	IBOutlet UITextField*					_txtfNameInput;	//Input name
	IBOutlet UIButton*						_btnOK;	//Accept button
	IBOutlet UIButton*						_btnCancel;	//Cancel button
	id<FileFolderActionsProtocol>			_delegate;	//The delegate
	BOOL									_isNewFolder;	//Is create new folder
	
}

@property (retain, nonatomic) id<FileFolderActionsProtocol> delegate;

- (void)setIsNewFolder:(BOOL)isNewFolder;	//UI for create new folder
- (void)setNameInputStr:(NSString *)nameStr;	//Give name for text box
- (void)setFocusOnTextFieldName;	//Show keyboard
- (IBAction)onOKBtn:(id)sender;	//Ok
- (IBAction)onCancelBtn:(id)sender;	//Cancel

@end
