//
//  FileActionsViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/25/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FilesViewController;

@interface FileActionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{	
	FilesViewController*					_delegate;
	IBOutlet UITableView*					_tblvActions;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
	
	BOOL									_bDelete;
	BOOL									_bNewFolder;
	BOOL									_bRename;
	BOOL									_bCopy;
	BOOL									_bMove;
	BOOL									_bPaste;
}

@property (nonatomic, retain) UITableView* _tblvActions;

- (void)setDelegate:(id)delegate;
- (void)localize;
- (void)enableDeleteAction:(BOOL)bEnable;
- (void)enableNewFolderAction:(BOOL)bEnable;
- (void)enableRenameAction:(BOOL)bEnable;
- (void)enableCopyAction:(BOOL)bEnable;
- (void)enableMoveAction:(BOOL)bEnable;
- (void)enablePasteAction:(BOOL)bEnable;
@end
