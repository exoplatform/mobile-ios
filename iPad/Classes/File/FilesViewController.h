//
//  FilesViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileContentDisplayController;
@class FileActionsViewController;
@class OptionsViewController;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//File information
@interface eXoFile: NSObject
{
	NSString *_fileName;	//File name
	NSString *_urlStr;	//File URL
	NSString *_contentType;	//File content type
	BOOL _isFolder;		//Is folder
}

@property(nonatomic, retain) NSString *_fileName;
@property(nonatomic, retain) NSString *_urlStr;
@property(nonatomic, retain) NSString *_contentType;
@property BOOL _isFolder;

- (BOOL)isFolder:(NSString *)urlStr; //Check if given URL is folder or not
-(id)initWithUrlStr:(NSString *)urlStr fileName:(NSString *)fileName; //Constructor

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Display file list
@interface FilesViewController : UIViewController <UINavigationControllerDelegate, 
													UITableViewDelegate, 
													UITableViewDataSource, 
													UIPopoverControllerDelegate>
{
	id										_delegate;	//The delagete
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//language index
	//Left and right image for the navigation
	IBOutlet UIButton*						_btnLeftEdgeNavigation;
	IBOutlet UIButton*						_btnRightEdgeNavigation;
	
	NSString*								_strRootDirectory;	//Root directory URL
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
	
	eXoFile*								_currenteXoFile;	//Current file
	eXoFile*								_fileForDeleteRename;	//File will be deleted
	eXoFile*								_fileForCopyMove;	//File will be copied, cut
	
	NSString*								_fileNameStackStr;	//File name tree
	
	UIImageView *imgViewEmptyPage;	//Display when folder is empty
	UILabel *labelEmptyPage;	//Empty text
}

@property (nonatomic, retain) NSString* _strRootDirectory;
@property (nonatomic, retain) FileContentDisplayController* _fileContentDisplayController;
@property (nonatomic, retain) FileActionsViewController* _fileActionsViewController;
@property (nonatomic, retain) OptionsViewController* _optionsViewController;
@property (nonatomic, retain) UITableView* _tbvFiles;
@property (nonatomic, retain) UIButton* _btnLeftEdgeNavigation;
@property (nonatomic, retain) UIButton* _btnRightEdgeNavigation;
@property (nonatomic, retain) UINavigationItem* _navigationBar;
@property (nonatomic, retain) UIActivityIndicatorView* _actiLoading;
@property (nonatomic, retain) UIBarButtonItem* _bbtnBack;
@property (nonatomic, retain) eXoFile* _currenteXoFile;
@property (nonatomic, retain) eXoFile* _fileForDeleteRename;
@property (nonatomic, retain) eXoFile* _fileForCopyMove;

- (void)setDelegate:(id)delegate;	//Set the delegate
- (void)localize;	//Language dictionary
- (int)getSelectedLanguage;	//Get current language index
- (NSDictionary*)getLocalization;	//Get current language dictionary
- (void)initWithRootDirectory;	//Constructor
- (NSMutableArray*)getPersonalDriveContent:(eXoFile *)file;	//Get file list
//File action
- (void)onAction:(NSString*)strAction;
- (void)doAction:(NSString *)strAction source:(NSString *)strSource destination:(NSString *)strDes;
//Ok for create new folder or rename file
- (void)onOKBtnOptionsView:(NSString*)strName;
- (void)onCancelBtnOptionView;	//Cancel rename, create folder
- (NSString *)urlForFileAction:(NSString *)url;	//Encode file URL

@end
