//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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
	BOOL									_isNewFolder;	//Is create new folder
	
}

@property (assign, nonatomic) id<FileFolderActionsProtocol> delegate;
@property (nonatomic, retain) File *fileToApplyAction;


- (void)setIsNewFolder:(BOOL)isNewFolder;	//UI for create new folder
- (void)setNameInputStr:(NSString *)nameStr;	//Give name for text box
- (void)setFocusOnTextFieldName;	//Show keyboard

- (void)updateUI;

@end
