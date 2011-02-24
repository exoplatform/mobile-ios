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

@interface eXoFile_iPhone: NSObject
{
	NSString *_fileName;
	NSString *_urlStr;
	NSString *_contentType;
	BOOL _isFolder;	
}

@property(nonatomic, retain) NSString *_fileName;
@property(nonatomic, retain) NSString *_urlStr;
@property(nonatomic, retain) NSString *_contentType;
@property BOOL _isFolder;

-(id)initWithUrlStr:(NSString *)urlStr fileName:(NSString *)fileName;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface eXoFilesView : UIView <UITableViewDelegate, UIImagePickerControllerDelegate> {
	
	IBOutlet UITableView*	_tblvFilesGrp;
	NSMutableArray*			_arrDicts;
	eXoApplicationsViewController* _delegate;
	eXoFileActionView *_fileActionViewShape;
	
	UIImageView *imgViewEmptyPage;
	UILabel *labelEmptyPage;
}

@property (nonatomic, readonly) IBOutlet UITableView* _tblvFilesGrp;
@property (nonatomic, readonly)	NSMutableArray*			_arrDicts;
@property (nonatomic, readonly)	eXoFileActionView *_fileActionViewShape;
@property (nonatomic, retain) UILabel *labelEmptyPage;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
- (void)setDriverContent:(NSMutableArray*)arrDriveContent withDelegate:(id)delegate;
-(void) onFileActionbtn;


@end
