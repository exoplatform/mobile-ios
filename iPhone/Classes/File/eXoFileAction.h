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

@interface eXoFileAction : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

	eXoApplicationsViewController *_delegate;
	eXoFilesView *_filesView;
	eXoFile_iPhone *_file;
	IBOutlet UITableView *tblFileAction;
	
	NSString *strTakePicture;
	NSString *strDelete;
	NSString *strCopy;
	NSString *strMove;
	NSString *strPaste;
	
	NSString *strCancel;
	
	BOOL _deleteFolderEnable;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(eXoApplicationsViewController *)delegate 
			filesView:(eXoFilesView *)filesView file:(eXoFile_iPhone *)file enableDeleteThisFolder:(BOOL)enable;

- (void)takePicture;

@end
