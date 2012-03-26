//
//  FileFolderActionsViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 01/09/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileActionsViewController.h"
#import "LanguageHelper.h"
#import "eXoViewController.h"

@class File;


@protocol FileFolderActionsProtocol 
//Method needed to call to create a new folder
-(void)createNewFolder:(NSString *)newFolderName;

//Method needed to rename a folder
-(void)renameFolder:(NSString *)newFolderName forFolder:(File *)folderToRename;

//Method needed when the Controller must be hidden
-(void)cancelFolderActions;

@end


@interface FileFolderActionsViewController :  eXoViewController <UITextFieldDelegate>
{
    File*                                   _fileToApplyAction;
    
	IBOutlet UITextField*					_txtfNameInput;	//Input name
	id<FileFolderActionsProtocol>			_delegate;	//The delegate
	BOOL									_isNewFolder;	//Is create new folder
	
}

@property (retain, nonatomic) id<FileFolderActionsProtocol> delegate;
@property (nonatomic, retain) File *fileToApplyAction;


- (void)setIsNewFolder:(BOOL)isNewFolder;	//UI for create new folder
- (void)setNameInputStr:(NSString *)nameStr;	//Give name for text box
- (void)setFocusOnTextFieldName;	//Show keyboard

- (void)updateUI;

@end
