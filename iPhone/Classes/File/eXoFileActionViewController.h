//
//  eXoFileAction.h
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eXoApplicationsViewController;
@class eXoFilesView;
@class eXoFile_iPhone;
@class eXoFileActionView;

//Action for file, folder
@interface eXoFileActionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

	eXoApplicationsViewController *_delegate; //point to main app view controller
	eXoFilesView *_filesView;	//file view
	eXoFile_iPhone *_file;	//file, folder info
	IBOutlet UITableView *tblFileAction;	//file action list
	
	NSString *strTakePicture;	//take a new picture
	NSString *strDelete;	//delete file
	NSString *strCopy;	//Copy file
	NSString *strMove;	//Cut file
	NSString *strPaste;	//Paste file
	
	NSString *strCancel;	//Cancel
	
	BOOL _deleteFolderEnable;	//Enable folder deleting

}
//Constructor
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(eXoApplicationsViewController *)delegate 
			filesView:(eXoFilesView *)filesView file:(eXoFile_iPhone *)file enableDeleteThisFolder:(BOOL)enable;

- (void)takePicture;	//Take a picture

@end
