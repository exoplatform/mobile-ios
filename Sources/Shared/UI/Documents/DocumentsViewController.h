//
//  DocumentsViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 29/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "FilesProxy.h"
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
        
    NSString *_stringForUploadPhoto;
    
    UITableView*   _tblFiles;

    CGRect displayActionDialogAtRect;
    
    UITableViewCell *_currentCell;
    
    UIPopoverController *_popoverPhotoLibraryController;
    
    BOOL isRoot;
    BOOL stop;
}

// Follow the Apple convention, the child view should keep a weak reference to parent only.
@property(nonatomic, assign) DocumentsViewController *parentController;
@property(nonatomic, retain) UIPopoverController *popoverPhotoLibraryController;
@property (nonatomic, assign) BOOL actionVisibleOnFolder;
@property BOOL isRoot;

// Check whether user can execute actions on the folder or not. 
- (BOOL)supportActionsForItem:(File *)item ofGroup:(NSString *)driveGroup;

-(void)emptyState;
- (void)showActionSheetForPhotoAttachment;
- (void)startRetrieveDirectoryContent;
- (void)contentDirectoryIsRetrieved;
- (void)askToMakeFolderActions:(BOOL)createNewFolder;
- (void)hideActionsPanel;
- (UITableView*)tblFiles;

//Use this method to init the Controller with a root file
- (id) initWithRootFile:(File *)rootFile withNibName:(NSString *)nibName; 
- (void)hideFileFolderActionsController;
- (void)buttonAccessoryClick:(id)sender;
- (UINavigationBar *)navigationBar;
- (NSString *)stringForUploadPhoto;
// This method is called when user chooses add new photo to the document. The derived classes should reinstall this method for apropriate display
- (void)showImagePickerForAddPhotoAction:(UIImagePickerController *)picker;

// Utility methods 
- (NSInteger)tagNumberFromIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathFromTagNumber:(NSInteger)tagNumber;


@end
