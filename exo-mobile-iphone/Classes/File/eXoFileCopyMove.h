//
//  eXoFileCopyMove.h
//  eXoApp
//
//  Created by exo on 11/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class eXoApplicationsViewController;
@class eXoFilesView;

@interface eXoFileCopyMove : UITableViewController<UINavigationControllerDelegate> {

	BOOL copyFile;
	
	
	UIBarButtonItem *_btnClose;
	UIBarButtonItem *_btnDone;
	
	NSString *sourceURL;
	NSString *destinationURL;
	
	NSDictionary*		_dictLocalize;
	
	eXoFilesView *_fileView;
	eXoApplicationsViewController *_delegate;
}

@property BOOL copyFile;
@property (nonatomic, retain) IBOutlet eXoFilesView* _fileView;
@property (nonatomic, retain) NSString *sourceURL;
@property (nonatomic, retain) NSString *destinationURL;


-(id)initWithStyle:(UITableViewStyle)style delegate:(eXoApplicationsViewController *)delegate;
//- (void)setDictLocalize:(NSDictionary*)dict;

@end
