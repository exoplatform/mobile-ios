//
//  eXoFilesView.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class eXoApplicationsViewController;
@class eXoFileActionView;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

//File, folder infor
@interface eXoFile_iPhone: NSObject
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

//Constructor
-(id)initWithUrlStr:(NSString *)urlStr fileName:(NSString *)fileName;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Files, folders view
@interface eXoFilesView : UIView <UITableViewDelegate, UIImagePickerControllerDelegate> {
	
	IBOutlet UITableView*	_tblvFilesGrp;	//Files, folders list view
	NSMutableArray*			_arrDicts;	//Files, folders list
	eXoApplicationsViewController* _delegate;	//Point to main app view controller
	eXoFileActionView *_fileActionViewShape;	//File action border
	
	UIImageView *imgViewEmptyPage;	//Empty page image view
	UILabel *labelEmptyPage;	///Empty page label view
}

@property (nonatomic, readonly) IBOutlet UITableView* _tblvFilesGrp;
@property (nonatomic, readonly)	NSMutableArray*			_arrDicts;
@property (nonatomic, readonly)	eXoFileActionView *_fileActionViewShape;
@property (nonatomic, retain) UILabel *labelEmptyPage;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;	//set table view editable
- (void)setDriverContent:(NSMutableArray*)arrDriveContent withDelegate:(id)delegate;	//Reload UI 
-(void) onFileActionbtn;	//Show file actions


@end
