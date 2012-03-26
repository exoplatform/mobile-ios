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

@interface eXoFile: NSObject
{
	NSString *_fileName;
	NSString *_fatherUrlStr;
	NSString *_contentType;
	BOOL _isFolder;	
}

@property(nonatomic, retain) NSString *_fileName;
@property(nonatomic, retain) NSString *_fatherUrlStr;
@property(nonatomic, retain) NSString *_contentType;
@property BOOL _isFolder;

-(id)initWithUrlStr:(NSString *)urlStr;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface eXoFilesView : UIView <UITableViewDelegate, UIImagePickerControllerDelegate> {
	
	IBOutlet UITableView*	_tblvFilesGrp;
	NSMutableArray*			_arrDicts;
	eXoApplicationsViewController* _delegate;
	eXoFileActionView *_fileActionViewShape;
	
}

@property (nonatomic, readonly) IBOutlet UITableView* _tblvFilesGrp;
@property (nonatomic, readonly)	NSMutableArray*			_arrDicts;
@property (nonatomic, readonly)	eXoFileActionView *_fileActionViewShape;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
- (void)setDriverContent:(NSMutableArray*)arrDriveContent withDelegate:(id)delegate;
-(void) onFileActionbtn;


@end
