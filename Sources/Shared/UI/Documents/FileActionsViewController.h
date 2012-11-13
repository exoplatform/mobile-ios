//
//  FileActionViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 29/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FileActionsProtocol 
//Method needed to retrieve the delete action
-(void)deleteFile:(NSString *)urlFileToDelete;

//Method needed to ctach when an move/copy action is requested over one file
-(void)moveOrCopyActionIsSelected;

//Method needed to retrieve the action to move a file
- (void)moveFileSource:urlSource
         toDestination:urlDestination;

//Method needed to retrieve the action to copy a file
- (void)copyFileSource:urlSource
         toDestination:urlDestination;

//Method needed to retrieve the action when the user ask an image
- (void)askToAddAPicture:(NSString *)urlDestination photoAlbum:(BOOL)photoAlbum;


//Method needed to ask to display the folder actions controller 
//(panel to renanme or create a new folder)
-(void)askToMakeFolderActions:(BOOL)createNewFolder;
-(void)askToAddPhoto:(NSString*)url;
-(void)askToShareFile:(NSString*)url;
@end



@class File;


@interface FileActionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
	File *_file;	//file, folder info
	IBOutlet UITableView *_tblFileAction;	//file action list
	
	NSString *_strTakePicture;	//take a new picture
	NSString *_strDelete;	//delete file
	NSString *_strCopy;	//Copy file
	NSString *_strMove;	//Cut file
	NSString *_strPaste;	//Paste file
	NSString *_strCancel;	//Cancel
    NSString *_strNewFolder; //NewFolder
    NSString *_strRenameFolder; //RenameFolder
	NSString *_strShare; //Share file
	BOOL _deleteFolderEnable;	//Enable folder deleting
    BOOL _createFolderEnable;	//Enable folder creating
    BOOL _renameFileEnable;	//Enable folder renaming
    
    id<FileActionsProtocol> fileActionsDelegate;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tblFileAction;
@property (nonatomic, retain) File *fileToApplyAction;
@property (nonatomic, retain) id<FileActionsProtocol> fileActionsDelegate;


//Constructor
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                 file:(File *)file 
                enableDeleteThisFolder:(BOOL)enableDeleteFolder
                enableCreateFolder:(BOOL)enableCreateFolder
                enableRenameFile:(BOOL)enableRenameFile
             delegate:(id<FileActionsProtocol>)actionsDelegate;

@end
