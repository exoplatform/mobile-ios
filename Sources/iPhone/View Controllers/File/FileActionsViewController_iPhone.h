//
//  FileActionsViewController_iPhone.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 24/05/11.
//  Copyright 2011 eXo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileActionsViewController.h"

@class File;


@interface FileActionsViewController_iPhone : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
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
	
	BOOL _deleteFolderEnable;	//Enable folder deleting
    
    id<FileActionsProtocol> fileActionsDelegate;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tblFileAction;
@property (nonatomic, retain) File *fileToApplyAction;
@property (nonatomic, retain) id<FileActionsProtocol> fileActionsDelegate;


//Constructor
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                 file:(File *)file 
enableDeleteThisFolder:(BOOL)enable
             delegate:(id<FileActionsProtocol>)actionsDelegate;

@end