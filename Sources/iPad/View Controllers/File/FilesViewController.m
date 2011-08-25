//
//  FilesViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import "FilesViewController.h"
#import "GadgetDisplayController.h"
#import "AuthenticateProxy.h"
#import "defines.h"
#import "FileContentDisplayController.h"
#import "FileActionsViewController.h"
#import "OptionsViewController.h"
#import "NSString+HTML.h"
#import "DataProcess.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "FilesProxy.h"
#import "LanguageHelper.h"


static NSString* kCellIdentifier = @"Cell";
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


@implementation FilesViewController

@synthesize _fileContentDisplayController;
@synthesize _fileActionsViewController;
@synthesize _optionsViewController;
@synthesize _tbvFiles;
@synthesize _btnLeftEdgeNavigation;
@synthesize _btnRightEdgeNavigation;
@synthesize _navigationBar;
@synthesize _actiLoading;
@synthesize _bbtnBack;
@synthesize _currenteXoFile, _fileForDeleteRename, _fileForCopyMove;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
		_arrDicts = [[NSMutableArray alloc] init];
		_bbtnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn)];
		_bbtnActions = [[UIBarButtonItem alloc] initWithTitle:@"Actions" style:UIBarButtonItemStylePlain target:self action:@selector(onActionBtn)];
		
		_actiLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[_actiLoading startAnimating];
		_actiLoading.hidesWhenStopped = YES;
		
		_fileContentDisplayController = [[FileContentDisplayController alloc] initWithNibName:@"FileContentDisplayController" bundle:nil];
		[_fileContentDisplayController setDelegate:self];

		_fileActionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" bundle:nil];
		[_fileActionsViewController setDelegate:self];

		_optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsViewController" bundle:nil];
		[_optionsViewController setDelegate:self];
		[_optionsViewController setIsNewFolder:YES];
		[_optionsViewController setNameInputStr:@""];
		

		_intIndexForAction = -1;
		_bCopy = NO;
		_bMove = NO;
		_bNewFolder = NO;
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[_navigationBar setRightBarButtonItem:_bbtnActions];
	[super viewDidLoad];
	
	labelEmptyPage = [[UILabel alloc] init];
	labelEmptyPage.backgroundColor = [UIColor clearColor];
	labelEmptyPage.textAlignment = UITextAlignmentCenter;
	labelEmptyPage.font = [UIFont systemFontOfSize:24];
	labelEmptyPage.text = Localize(@"EmptyPage");
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    _delegate = nil;
    
    [_btnLeftEdgeNavigation release];
    _btnLeftEdgeNavigation = nil;
    
    [_btnRightEdgeNavigation release];
    _btnRightEdgeNavigation = nil;
    
    [_tbvFiles release];
    _tbvFiles = nil;
    
    [_arrDicts release];
    _arrDicts = nil;
    
    [_navigationBar release];
    _navigationBar = nil;
    
    [_bbtnBack release];
    _bbtnBack = nil;
    
    [_bbtnActions release];
    _bbtnActions = nil;
    
    [_actiLoading release];
    _actiLoading = nil;
    
    [_fileContentDisplayController release];
    _fileContentDisplayController = nil;
    
    [_fileActionsViewController release];
    _fileActionsViewController = nil;
    
    [_optionsViewController release];
    _optionsViewController = nil;
    
    [popoverController release];
    popoverController = nil;
    
    [optionsPopoverController release];
    optionsPopoverController = nil;
    
    [_currenteXoFile release];
    _currenteXoFile = nil;
    
    [_fileForDeleteRename release];
    _fileForDeleteRename = nil;
    
    [_fileForCopyMove release];
    _fileForCopyMove = nil;
    
    [imgViewEmptyPage release];
    imgViewEmptyPage = nil;
    
    [labelEmptyPage release];
    labelEmptyPage = nil;
    
    [super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)setFileContentDisplayView:(GadgetDisplayController*)fileContentDisplayView
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	[popoverController dismissPopoverAnimated:YES];
	
	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
		imgViewEmptyPage.frame = CGRectMake(0, 43, 768, 976);
		labelEmptyPage.frame = CGRectMake(0, 670, 768, 40);
	} else {
		imgViewEmptyPage.frame = CGRectMake(0, 43, 703, 705);
		labelEmptyPage.frame = CGRectMake(0, 500, 703, 40);
	}

    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
}

-(void)startInProgress 
{	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	UIBarButtonItem* progressBtn = [[UIBarButtonItem alloc] initWithCustomView:_actiLoading];
	[_navigationBar setLeftBarButtonItem:progressBtn];
	//[_navigationBar setRightBarButtonItem:nil];;
	[pool release];	
}

-(void)endProgress
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    FilesProxy *fileProxy = [FilesProxy sharedInstance];
    
	if([_currenteXoFile.urlStr isEqualToString:fileProxy._strUserRepository])
	{
		[_navigationBar setTitle:@"Documents Application"];
		[_navigationBar setLeftBarButtonItem:nil];
	}
	else
	{
		[_navigationBar setTitle:_currenteXoFile.fileName];
		[_navigationBar setLeftBarButtonItem:_bbtnBack];
	}	
    
	[pool release];
}

- (void)initWithRootDirectory:(BOOL)isCompatibleWithPlatform35
{
    FilesProxy *fileProxy = [FilesProxy sharedInstance];
    _currenteXoFile = [fileProxy initialFileForRootDirectory];
    
}

- (NSMutableArray*)getPersonalDriveContent:(File *)file
{
    
    NSData* dataReply = [[AuthenticateProxy sharedInstance] sendRequestWithAuthorization:file.urlStr];
	//NSData* dataReply = [[_delegate getConnection] sendRequestWithAuthorization:file._urlStr];
	NSString* strData = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
	
	NSMutableArray* arrDicts = [[NSMutableArray alloc] init];
	
	NSRange range1;
	NSRange range2;
	do 
	{
		range1 = [strData rangeOfString:@"alt=\"\"> "];
		range2 = [strData rangeOfString:@"</a>"];
		
		if(range1.length > 0)
		{
			NSString *fileName = [strData substringWithRange:NSMakeRange(range1.length + range1.location, range2.location - range1.location - range1.length)];
			
			fileName = [fileName stringByDecodingHTMLEntities];
			if(![fileName isEqualToString:@".."])
			{
				NSRange range3 = [strData rangeOfString:@"<a href=\""];
				NSRange range4 = [strData rangeOfString:@"\"><img src"];
				NSString *urlStr = [strData substringWithRange:NSMakeRange(range3.length + range3.location, 
																		   range4.location - range3.location - range3.length)];
				
				File *fileTmp = [[File alloc] initWithUrlStr:urlStr fileName:fileName];
				[arrDicts addObject:fileTmp];
			}
			
		}
		if(range2.length > 0)
			strData = [strData substringFromIndex:range2.location + range2.length];
	} while (range1.length > 0);
	
	[_arrDicts removeAllObjects];
	_arrDicts = [arrDicts retain];
	
	return arrDicts;
	
}

- (void)onBackBtn
{
	NSThread* startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	[startThread start];
	
	imgViewEmptyPage.hidden = YES;
	    
	_currenteXoFile.urlStr = [_currenteXoFile.urlStr stringByDeletingLastPathComponent];
	_currenteXoFile.urlStr = [_currenteXoFile.urlStr stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	_currenteXoFile.fileName = [_currenteXoFile.urlStr lastPathComponent];
    
	[self getPersonalDriveContent:_currenteXoFile];
	[_tbvFiles reloadData];
	
	if(_currenteXoFile.isFolder)
	{
		[_navigationBar setRightBarButtonItem:_bbtnActions];
	}
		
	else 
	{
		[_navigationBar setRightBarButtonItem:nil];
	}

	if ([[self.view subviews] lastObject] == _fileContentDisplayController.view) 
	{
		[_navigationBar setRightBarButtonItem:_bbtnActions];
		[_fileContentDisplayController._wvFileContentDisplay loadHTMLString:@"<html><body></body></html>" baseURL:nil];
		[[_fileContentDisplayController view] removeFromSuperview];
	}	
	
	[startThread release];	
	[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
}

- (void)onActionBtn
{
	[_fileActionsViewController enableDeleteAction:NO];
	[_fileActionsViewController enableNewFolderAction:YES];
	[_fileActionsViewController enableRenameAction:NO];
	[_fileActionsViewController enableCopyAction:NO];
	[_fileActionsViewController enableMoveAction:NO];
	
	if(_bCopy || _bMove)
	{
		_fileForDeleteRename = [_currenteXoFile retain];
		[_fileActionsViewController enablePasteAction:YES];
	}
	else 
	{
		
		[_fileActionsViewController enablePasteAction:NO];
	}	
	[_fileActionsViewController._tblvActions reloadData];
	
	
	CGRect tblvRect = [_tbvFiles frame];
	CGRect btnActionRect = CGRectMake(tblvRect.origin.x + tblvRect.size.width - 50, tblvRect.origin.y - 5, 1, 1);
	popoverController = [[UIPopoverController alloc] initWithContentViewController:_fileActionsViewController];
	[popoverController setPopoverContentSize:CGSizeMake(240, 285) animated:YES];
	[popoverController presentPopoverFromRect:btnActionRect inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];		
}

- (NSString *)urlForFileAction:(NSString *)url
{
	url = [DataProcess encodeUrl:url];
	
	NSRange range;
	range = [url rangeOfString:@"http://"];
	if(range.length == 0)
		url = [url stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	
	return url;
	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 44;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	int n = [_arrDicts count];
	
	return n;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 5.0, 400.0, 30.0)];
        titleLabel.tag = kTagForCellSubviewTitleLabel;
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        [cell addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 34.0, 34.0)];
        imgView.tag = kTagForCellSubviewImageView;
        [cell addSubview:imgView];
        [imgView release];
    }
	
	UILabel* titleLabel = (UILabel *)[cell viewWithTag:kTagForCellSubviewTitleLabel];
    UIImageView* imgView = (UIImageView* )[cell viewWithTag:kTagForCellSubviewImageView];
    
	File *file = [_arrDicts objectAtIndex:indexPath.row];
	
	titleLabel.text = [file.fileName stringByDecodingHTMLEntities];
	
	if(file.isFolder)
	{
		imgView.image = [UIImage imageNamed:@"folder.png"];
	}
	else
	{		
		imgView.image = [UIImage imageNamed:[File fileType:file.fileName]];
	}
	
	if (imgViewEmptyPage == nil) {
		imgViewEmptyPage = [[UIImageView alloc] initWithFrame:tableView.frame];
		imgViewEmptyPage.center = tableView.center;
		imgViewEmptyPage.image = [UIImage imageNamed:@"emptypage.png"];
		
		[imgViewEmptyPage addSubview:labelEmptyPage];
		[self.view addSubview:imgViewEmptyPage];
		imgViewEmptyPage.hidden = YES;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	CGRect tblvRect = [_tbvFiles frame];
	_intIndexForAction = indexPath.row;
	
	_fileForDeleteRename = [[_arrDicts objectAtIndex:_intIndexForAction] retain];
	
	[_fileActionsViewController enableDeleteAction:YES];
	[_fileActionsViewController enableNewFolderAction:NO];
	[_fileActionsViewController enableRenameAction:YES];
	[_fileActionsViewController enableCopyAction:NO];
	[_fileActionsViewController enableMoveAction:NO];
	if(!_fileForDeleteRename.isFolder)
	{
		[_fileActionsViewController enableCopyAction:YES];
		[_fileActionsViewController enableMoveAction:YES];
	}
	if(_bCopy || _bMove)
	{
		[_fileActionsViewController enablePasteAction:YES];
	}
	else 
	{
		[_fileActionsViewController enablePasteAction:NO];
	}

	[_fileActionsViewController._tblvActions reloadData];
	
	float offset = 44.0 * _intIndexForAction + 22;
	CGRect rect = CGRectMake(tblvRect.origin.x + tblvRect.size.width - 35, offset, 1, 1);
	popoverController = [[UIPopoverController alloc] initWithContentViewController:_fileActionsViewController];
	[popoverController setPopoverContentSize:CGSizeMake(240, 285) animated:YES];
	[popoverController presentPopoverFromRect:rect inView:_tbvFiles permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];		
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	File *file = [_arrDicts objectAtIndex:indexPath.row];
	
	if(file.isFolder)
	{
        _currenteXoFile = file;
        
		NSThread* startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
		[startThread start];
	
		[self getPersonalDriveContent:file];
		[_navigationBar setLeftBarButtonItem:_bbtnBack];
		[_tbvFiles reloadData];
		
		[startThread release];
		[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
		
		if([_arrDicts count] == 0) {
			imgViewEmptyPage.hidden = NO;
			
		}
		
	}
	else
	{	
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_fileContentDisplayController invokeByController:self isStackStartView:FALSE];
        
		//[_navigationBar setRightBarButtonItem:nil];
		//[[_fileContentDisplayController view] setFrame:[_tbvFiles frame]];

		NSURL *url = [NSURL URLWithString:[file.urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
		[_fileContentDisplayController startDisplayFileContent:url];
		//[[self view] addSubview:[_fileContentDisplayController view]];
		
		//[_navigationBar setTitle:_currenteXoFile._fileName];
		//[_navigationBar setLeftBarButtonItem:_bbtnBack];
	}

}


#pragma mark

- (void)onAction:(NSString*)strAction
{
	NSString *strSource;
	NSString *strDestination;
	
	if([strAction isEqualToString:@"DELETE"] == YES)
	{
		[self doAction:@"DELETE" source:[self urlForFileAction:_fileForDeleteRename.urlStr] destination:nil];
	}
	else if([strAction isEqualToString:@"NEWFOLDER"] == YES)
	{
		_bNewFolder = YES;
		
		[popoverController dismissPopoverAnimated:YES];
		[_optionsViewController setIsNewFolder:YES];
		[_optionsViewController setNameInputStr:@""];
		optionsPopoverController = [[UIPopoverController alloc] initWithContentViewController:_optionsViewController];
		[optionsPopoverController setPopoverContentSize:CGSizeMake(320, 140) animated:YES];
	
		CGRect rect = CGRectMake([_tbvFiles frame].origin.x + [_tbvFiles frame].size.width - 50, 0, 1, 1);
		[optionsPopoverController presentPopoverFromRect:rect inView:_tbvFiles permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		[_optionsViewController setFocusOnTextFieldName];
	}
	else if([strAction isEqualToString:@"RENAME"] == YES)
	{
		
		float offset = 44.0 * _intIndexForAction + 30;
		CGRect rect;
		[popoverController dismissPopoverAnimated:NO];
		[_optionsViewController setIsNewFolder:NO];
		[_optionsViewController setNameInputStr:_fileForDeleteRename.fileName];
		optionsPopoverController = [[UIPopoverController alloc] initWithContentViewController:_optionsViewController];
		[optionsPopoverController setPopoverContentSize:CGSizeMake(320, 140) animated:YES];
		if(offset < 150)
		{
			rect = CGRectMake([_tbvFiles frame].origin.x + 70, offset, 1, 1);
			[optionsPopoverController presentPopoverFromRect:rect inView:_tbvFiles permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		}
		else 
		{
			rect = CGRectMake([_tbvFiles frame].origin.x + 70, offset - 25, 1, 1);
			[optionsPopoverController presentPopoverFromRect:rect inView:_tbvFiles permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
		}
		[_optionsViewController setFocusOnTextFieldName];
	}
	else if([strAction isEqualToString:@"COPY"] == YES)
	{
		_bCopy = YES;
	}
	else if([strAction isEqualToString:@"MOVE"] == YES)
	{
		_bMove = YES;
	}
	else if([strAction isEqualToString:@"PASTE"] == YES)
	{
		strSource = [self urlForFileAction:_fileForCopyMove.urlStr];
		strDestination = [self urlForFileAction:[_fileForDeleteRename.urlStr stringByAppendingPathComponent:[_fileForCopyMove.urlStr lastPathComponent]]];
		
		if(_bCopy)
		{
			[self doAction:@"COPY" source:strSource destination:strDestination];
			_bCopy = NO;
		}
		if(_bMove)
		{
			[self doAction:@"MOVE" source:strSource destination:strDestination];
			_bMove = NO;			
		}
	}
	
	[popoverController dismissPopoverAnimated:YES];
	_intIndexForAction = -1;
}

- (void)doAction:(NSString *)strAction source:(NSString *)strSource destination:(NSString *)strDes
{
	NSHTTPURLResponse* response;
	NSError* error;
	
	NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_PASSWORD];
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:[NSURL URLWithString:strSource]]; 
	
	if([strAction isEqualToString:@"DELETE"])
	{
		[request setHTTPMethod:@"DELETE"];
	}
	if([strAction isEqualToString:@"MKCOL"])
	{
		[request setHTTPMethod:@"MKCOL"];
	}
	else if([strAction isEqualToString:@"COPY"])
	{
		[request setHTTPMethod:@"COPY"];
		[request setValue:strDes forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
	}
	else if([strAction isEqualToString:@"MOVE"])
	{
		[request setHTTPMethod:@"MOVE"];
		[request setValue:strDes forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
	}
	
	NSString* s = @"Basic ";
	NSString* author = [s stringByAppendingString: 
						[[_delegate getConnection] stringEncodedWithBase64:
						 [NSString stringWithFormat:@"%@:%@", userName, password]]];
	
	[request setValue:author forHTTPHeaderField:@"Authorization"];
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSUInteger statusCode = [response statusCode];
	
	if(!(statusCode >= 200 && statusCode < 300))
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:[NSString stringWithFormat:@"Error %d!", statusCode] 
							  message:@"Can not transfer file" delegate:self 
							  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	_arrDicts = [self getPersonalDriveContent:_currenteXoFile];
	if([_arrDicts count] > 0) {
		imgViewEmptyPage.hidden = YES;
	} else {
		
		imgViewEmptyPage.hidden = NO;
		
	}

		
	[_tbvFiles reloadData];
}

- (void)onOKBtnOptionsView:(NSString*)strName
{
	UIAlertView *alert;
	BOOL bExist = NO;
	NSString* tmpStr;
	
	if(_bNewFolder)
	{
		if([strName length] > 0)
		{
			for (int i = 0; i < [_arrDicts count]; i++)
			{
				File *file = [[_arrDicts objectAtIndex:i] retain];
				if([strName isEqualToString:file.fileName])
				{
					bExist = YES;
					
					if([[LanguageHelper sharedInstance] getSelectedLanguage] == 0)
					{
						tmpStr = [NSString stringWithFormat:@"This name \"%@\" is already taken! Please choose a different name", strName];
					}
					else 
					{
						tmpStr = [NSString stringWithFormat:@"Le nom \"%@\" est déjà utilisé. Veuillez entrer un autre nom", strName];
					}

					alert = [[UIAlertView alloc] 
							 initWithTitle:Localize(@"Info Message") 
							 message: tmpStr
							 delegate:self 
							 cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
					[alert show];
					[alert release];
					break;
				}
			}
			
			if (!bExist) 
			{
				if(!_currenteXoFile.isFolder) {
					strName = [strName stringByEncodingHTMLEntities];
					strName = [DataProcess encodeUrl:strName];
				}

				NSString* strNewFolderPath = [self urlForFileAction:[_currenteXoFile.urlStr stringByAppendingPathComponent:strName]];
				
				[self doAction:@"MKCOL" source: strNewFolderPath destination:@""];				
			}
		}
		else 
		{
			if([[LanguageHelper sharedInstance] getSelectedLanguage] == 0)
			{
				tmpStr = @"The new name is empty! Please input a valid name";
			}
			else 
			{
				tmpStr = @"Le nom du fichier ne peut pas etre vide. Veuillez entrer un nom valide";
			}
			
			alert = [[UIAlertView alloc] 
					 initWithTitle:Localize(@"Info Message")
					 message:tmpStr 
					 delegate:self 
					 cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}
		_bNewFolder = NO;
	}
	else
	{
		if([strName length] > 0)
		{
			for (int i = 0; i < [_arrDicts count]; i++)
			{
				File *file = [[_arrDicts objectAtIndex:i] retain];
				if([strName isEqualToString:file.fileName])
				{
					bExist = YES;
					if([[LanguageHelper sharedInstance] getSelectedLanguage] == 0)
					{
						tmpStr = [NSString stringWithFormat:@"This name \"%@\" is already taken! Please choose a different name", strName];
					}
					else 
					{
						tmpStr = [NSString stringWithFormat:@"Le nom \"%@\" est déjà utilisé. Veuillez entrer un autre nom", strName];
					}
					
					alert = [[UIAlertView alloc] 
							 initWithTitle:Localize(@"Info Message") 
							 message:tmpStr 
							 delegate:self 
							 cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
					[alert show];
					[alert release];
					break;
				}
			}
			if (!bExist) 
			{
				if(!_currenteXoFile.isFolder) {
					strName = [strName stringByEncodingHTMLEntities];
					strName = [DataProcess encodeUrl:strName];
				}
				
				NSString* strRenamePath = [self urlForFileAction:[_currenteXoFile.urlStr stringByAppendingPathComponent:strName]];
				NSString *strSource = [self urlForFileAction: _fileForDeleteRename.urlStr];
				
				[self doAction:@"MOVE" source:strSource destination:strRenamePath];
			}
		}
		else 
		{
			if([[LanguageHelper sharedInstance] getSelectedLanguage] == 0)
			{
				tmpStr = @"The new name is empty! Please input a valid name";
		}
		else 
		{
				tmpStr = @"Le nom du fichier ne peut pas etre vide. Veuillez entrer un nom valide";
			}
			
			UIAlertView *alert = [[UIAlertView alloc] 
								  initWithTitle:Localize(@"Info Message")
								  message:tmpStr delegate:self 
								  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}
	}	
	[optionsPopoverController dismissPopoverAnimated:YES];
}

- (void)onCancelBtnOptionView
{
	[optionsPopoverController dismissPopoverAnimated:YES];
	_bNewFolder = NO;
}
@end
