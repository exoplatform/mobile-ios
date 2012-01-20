//
//  DocumentsViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 29/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "FilesProxy.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "FileActionsViewController.h"
#import "FileFolderActionsViewController.h"
#import "URLAnalyzer.h"
#import "eXoViewController.h"
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"

#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]
#define kHeightForSectionHeader 40

@interface DocumentsViewController : eXoViewController <FileActionsProtocol, FileFolderActionsProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, ATMHudDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate> {
    
    DocumentsViewController *_parentController;
    File *_rootFile;
    
    NSMutableDictionary *_dicContentOfFolder;
    NSArray *_arrayContentOfRootFile;
    
    FilesProxy *_filesProxy;
    
    File *fileToApplyAction;
    
    ATMHud *_hudFolder;//Heads up display
        
    NSString *_stringForUploadPhoto;
    
    FileFolderActionsViewController *_fileFolderActionsController;
    
    IBOutlet UITableView*   _tblFiles;

    CGRect displayActionDialogAtRect;
    
    UIPopoverController *_popoverPhotoLibraryController;
    
    BOOL isRoot;
    BOOL stop;
}

@property(nonatomic, retain) DocumentsViewController *parentController;
@property BOOL isRoot;

-(void)emptyState;
-(void)setHudPosition;
-(void)showHUDWithMessage:(NSString *)message;
-(void)hideHUDWithMessage:(NSString *)message;
- (void)showActionSheetForPhotoAttachment;
- (void)startRetrieveDirectoryContent;
- (void)contentDirectoryIsRetrieved;
- (void)askToMakeFolderActions:(BOOL)createNewFolder;
- (void)hideActionsPanel;

//Use this method to init the Controller with a root file
- (id) initWithRootFile:(File *)rootFile withNibName:(NSString *)nibName; 
- (void)hideFileFolderActionsController;
- (void)buttonAccessoryClick:(id)sender;
- (UINavigationBar *)navigationBar;
- (NSString *)stringForUploadPhoto;



@end
