//
//  FileActionsViewController_iPad.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/25/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FilesViewController;

//File action view controller
@interface FileActionsViewController_iPad : UIViewController <UITableViewDelegate, UITableViewDataSource>
{	
	FilesViewController*					_delegate; //Point to FilesViewController
	IBOutlet UITableView*					_tblvActions;	//Display list of action
	
	BOOL									_bDelete;	//Is deleting file
	BOOL									_bNewFolder;	//Is creating a new folder
	BOOL									_bRename;	//Is renaming file
	BOOL									_bCopy;	//Is copying file
	BOOL									_bMove;	//Is moving file
	BOOL									_bPaste;	//Is pasting file
}

@property (nonatomic, retain) UITableView* _tblvActions;

- (void)setDelegate:(id)delegate;	//Set the delegate
//Enable file actions
- (void)enableDeleteAction:(BOOL)bEnable;	
- (void)enableNewFolderAction:(BOOL)bEnable;
- (void)enableRenameAction:(BOOL)bEnable;
- (void)enableCopyAction:(BOOL)bEnable;
- (void)enableMoveAction:(BOOL)bEnable;
- (void)enablePasteAction:(BOOL)bEnable;

@end
