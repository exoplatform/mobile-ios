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
////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface eXoFile: NSObject
{
	NSString *_fileName;
	NSString *_fatherUrlStr;
	NSString *_contentType;
	BOOL _isFolder;	
}

@property(nonatomic, retain) NSString *_fileName;
@property(nonatomic, retain) NSString *_fatherUrlStr;
@property(nonatomic, retain) NSString *_contentType;
@property BOOL _isFolder;

- (BOOL)isFolder:(NSString *)urlStr fileName:(NSString *)name;
-(id)initWithUrlStr:(NSString *)urlStr;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface FilesViewController : UIViewController <UINavigationControllerDelegate, 
													UITableViewDelegate, 
													UITableViewDataSource, 
													UIPopoverControllerDelegate>
{
	id										_delegate;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
	
	IBOutlet UIButton*						_btnLeftEdgeNavigation;
	IBOutlet UIButton*						_btnRightEdgeNavigation;
	
	NSString*								_strRootDirectory;
	IBOutlet UITableView*					_tbvFiles;
	NSMutableArray*							_arrDicts;
	
	IBOutlet UINavigationItem*				_navigationBar;
	UIBarButtonItem*						_bbtnBack;
	UIBarButtonItem*						_bbtnActions;
	UIActivityIndicatorView*				_actiLoading;
	
	FileContentDisplayController*			_fileContentDisplayController;
	FileActionsViewController*				_fileActionsViewController;
	OptionsViewController*					_optionsViewController;
	UIPopoverController*					popoverController;
	UIPopoverController*					optionsPopoverController;
	
	int										_intIndexForAction;
	BOOL									_bCopy;
	BOOL									_bMove;	
	BOOL									_bNewFolder;
	
	eXoFile*								_currenteXoFile;	
	eXoFile*								_fileForDeleteRename;
	eXoFile*								_fileForCopyMove;
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

- (void)setDelegate:(id)delegate;
- (void)localize;
- (int)getSelectedLanguage;
- (NSDictionary*)getLocalization;
- (void)initWithRootDirectory;
- (NSMutableArray*)getPersonalDriveContent:(eXoFile *)file;
- (void)onAction:(NSString*)strAction;
- (void)doAction:(NSString *)strAction source:(NSString *)strSource destination:(NSString *)strDes;
- (void)onOKBtnOptionsView:(NSString*)strName;
- (void)onCancelBtnOptionView;
- (NSString *)urlForFileAction:(eXoFile *)file;

@end
