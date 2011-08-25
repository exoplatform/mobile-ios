//
//  FilesViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@class FileContentDisplayController;
@class FileActionsViewController;
@class OptionsViewController;


////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Display file list
@interface FilesViewController : UIViewController <UINavigationControllerDelegate, 
													UITableViewDelegate, 
													UITableViewDataSource, 
													UIPopoverControllerDelegate>
{
	id										_delegate;	//The delagete
	
	//Left and right image for the navigation
	IBOutlet UIButton*						_btnLeftEdgeNavigation;
	IBOutlet UIButton*						_btnRightEdgeNavigation;
	
	IBOutlet UITableView*					_tbvFiles;	//show file list
	NSMutableArray*							_arrDicts;	//File list
	
	IBOutlet UINavigationItem*				_navigationBar;	//Navigation bar
	UIBarButtonItem*						_bbtnBack;	//Up to parent directory 
	UIBarButtonItem*						_bbtnActions;	//Show action view
	UIActivityIndicatorView*				_actiLoading;	//Loading indecator
	
	FileContentDisplayController*			_fileContentDisplayController; //Display file content
	FileActionsViewController*				_fileActionsViewController;	//Display file actions
	OptionsViewController*					_optionsViewController;	//Add or rename file
	//Add, rename file pop up windows
	UIPopoverController*					popoverController;
	UIPopoverController*					optionsPopoverController;
	
	int										_intIndexForAction; //Action index
	BOOL									_bCopy;	//Is copy file
	BOOL									_bMove;	 //Is cut file
	BOOL									_bNewFolder;	//Is create new folder
	
	File*                                   _currenteXoFile;	//Current file
	File*                                   _fileForDeleteRename;	//File will be deleted
	File*                                   _fileForCopyMove;	//File will be copied, cut
	
	NSString*								_fileNameStackStr;	//File name tree
	
	UIImageView *imgViewEmptyPage;	//Display when folder is empty
	UILabel *labelEmptyPage;	//Empty text
}

@property (nonatomic, retain) FileContentDisplayController* _fileContentDisplayController;
@property (nonatomic, retain) FileActionsViewController* _fileActionsViewController;
@property (nonatomic, retain) OptionsViewController* _optionsViewController;
@property (nonatomic, retain) UITableView* _tbvFiles;
@property (nonatomic, retain) UIButton* _btnLeftEdgeNavigation;
@property (nonatomic, retain) UIButton* _btnRightEdgeNavigation;
@property (nonatomic, retain) UINavigationItem* _navigationBar;
@property (nonatomic, retain) UIActivityIndicatorView* _actiLoading;
@property (nonatomic, retain) UIBarButtonItem* _bbtnBack;
@property (nonatomic, retain) File* _currenteXoFile;
@property (nonatomic, retain) File* _fileForDeleteRename;
@property (nonatomic, retain) File* _fileForCopyMove;

- (void)setDelegate:(id)delegate;	//Set the delegate
- (void)initWithRootDirectory:(BOOL)isCompatibleWithPlatform35;	//Constructor
- (NSMutableArray*)getPersonalDriveContent:(File *)file;	//Get file list
//File action
- (void)onAction:(NSString*)strAction;
- (void)doAction:(NSString *)strAction source:(NSString *)strSource destination:(NSString *)strDes;
//Ok for create new folder or rename file
- (void)onOKBtnOptionsView:(NSString*)strName;
- (void)onCancelBtnOptionView;	//Cancel rename, create folder
- (NSString *)urlForFileAction:(NSString *)url;	//Encode file URL

@end
