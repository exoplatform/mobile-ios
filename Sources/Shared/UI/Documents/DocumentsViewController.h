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

@interface DocumentsViewController : eXoViewController <FileActionsProtocol, FileFolderActionsProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, ATMHudDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    File *_rootFile;
    
    NSArray *_arrayContentOfRootFile;
    
    FilesProxy *_filesProxy;
    
    ATMHud *_hudFolder;//Heads up display
        
    NSString *_stringForUploadPhoto;
    
    FileFolderActionsViewController *_fileFolderActionsController;
    
    IBOutlet UITableView*   _tblFiles;

    CGRect displayActionDialogAtRect;
    
    UIPopoverController *popoverPhotoLibraryController;
    
    IBOutlet UINavigationBar* _navigationBar;
    
}
-(void)emptyState;
-(void)setHudPosition;
-(void)showHUDWithMessage:(NSString *)message;
- (void)showActionSheetForPhotoAttachment;
- (void)startRetrieveDirectoryContent;

//Use this method to init the Controller with a root file
- (id) initWithRootFile:(File *)rootFile withNibName:(NSString *)nibName; 
- (void)hideFileFolderActionsController;
- (void)buttonAccessoryClick:(id)sender;
- (UINavigationBar *)navigationBar;
- (NSString *)stringForUploadPhoto;
@end
