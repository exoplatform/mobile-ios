//
//  FilesViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import "FilesViewController.h"
#import "MainViewController.h"
#import "Connection.h"
#import "defines.h"
#import "FileContentDisplayController.h"
#import "FileActionsViewController.h"
#import "OptionsViewController.h"

static NSString* kCellIdentifier = @"Cell";

NSString* fileType(NSString *fileName)
{	
	if([fileName length] < 5)
	{
		return @"unknownFileIcon.png";
	}	
	else
	{
		NSRange range = NSMakeRange([fileName length] - 4, 4);
		NSString *tmp = [fileName substringWithRange:range];
		
		if([tmp isEqualToString:@".png"] || [tmp isEqualToString:@".jpg"] || [tmp isEqualToString:@".jpeg"] || 
		   [tmp isEqualToString:@".gif"] || [tmp isEqualToString:@".psd"] || [tmp isEqualToString:@".tiff"] ||
		   [tmp isEqualToString:@".bmp"] || [tmp isEqualToString:@".pict"])
		{	
			return @"image.png";
		}	
		if([tmp isEqualToString:@".rtf"] || [tmp isEqualToString:@".txt"])
		{	
			return @"txt.png";
		}	
		if([tmp isEqualToString:@".pdf"])
		{	
			return @"pdf.png";
		}
		if([tmp isEqualToString:@".doc"])
		{	
			return @"word.png";
		}
		if([tmp isEqualToString:@".ppt"])
		{	
			return @"ppt.png";
		}
		if([tmp isEqualToString:@".xls"])
		{	
			return @"xls.png";
		}
		if([tmp isEqualToString:@".swf"])
		{	
			return @"swf.png";
		}
		if([tmp isEqualToString:@".mp3"] || [tmp isEqualToString:@".aac"] || [tmp isEqualToString:@".wav"])
		{	
			return @"music.png";
		}	
		if([tmp isEqualToString:@".mov"])
		{	
			return @"video.png";
		}
		return @"unknownFileIcon.png";
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation eXoFile

@synthesize _fileName, _fatherUrlStr, _contentType, _isFolder;

-(BOOL)isFolder:(NSString *)urlStr
{
	Connection *cnn = [[Connection alloc] init];
	
	_contentType = [[NSString alloc] initWithString:@""];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	BOOL returnValue = FALSE;
	
	NSURL* url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:url];
	[request setTimeoutInterval:60.0];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	
	[request setHTTPMethod:@"PROPFIND"];
	
	[request setHTTPBody: [[NSString stringWithString: @"<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:propfind xmlns:D=\"DAV:\">"
							"<D:prop><D:getcontenttype/></D:prop></D:propfind>"] dataUsingEncoding:NSUTF8StringEncoding]]; 
	
	[request setValue:[cnn stringOfAuthorizationHeaderWithUsername:username password:password] forHTTPHeaderField:@"Authorization"];
	
	NSData *dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *responseStr = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
	
	NSRange dirRange = [responseStr rangeOfString:@"<D:getcontenttype/></D:prop>"];
	
	if(dirRange.length > 0)
	{	
		returnValue = TRUE;
		
	}
	else
	{
		NSRange contentTypeRange1 = [responseStr rangeOfString:@"<D:getcontenttype>"];
		NSRange contentTypeRange2 = [responseStr rangeOfString:@"</D:getcontenttype>"];
		if(contentTypeRange1.length > 0 && contentTypeRange2.length > 0)
			_contentType = [responseStr substringWithRange:
							NSMakeRange(contentTypeRange1.location + contentTypeRange1.length, 
										contentTypeRange2.location - contentTypeRange1.location - contentTypeRange1.length)];
	}
	
	[cnn release];
	
	return returnValue;
}

-(NSString *)convertPathToUrlStr:(NSString *)path
{
	return [path stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
}

-(id)initWithUrlStr:(NSString *)urlStr
{
	if(self = [super init])
	{
		_fileName = [[NSString alloc] initWithString:[urlStr lastPathComponent]];
		_fatherUrlStr = [[NSString alloc] initWithString:[self convertPathToUrlStr:[urlStr stringByDeletingLastPathComponent]]];
		_isFolder = [self isFolder:urlStr];
	}
	
	return self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation FilesViewController

@synthesize _strRootDirectory;
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
		_bbtnActions = [[UIBarButtonItem alloc] initWithTitle:@"Action" style:UIBarButtonItemStylePlain target:self action:@selector(onActionBtn)];
		
		_actiLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[_actiLoading startAnimating];
		_actiLoading.hidesWhenStopped = YES;
		
		_fileContentDisplayController = [[FileContentDisplayController alloc] initWithNibName:@"FileContentDisplayController" bundle:nil];
		[_fileContentDisplayController setDelegate:self];

		_fileActionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" bundle:nil];
		[_fileActionsViewController setDelegate:self];

		_optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsViewController" bundle:nil];
		[_optionsViewController setDelegate:self];

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
	[self localize];
	[_navigationBar setRightBarButtonItem:_bbtnActions];
	[super viewDidLoad];
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
    [super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (int)getSelectedLanguage
{
	return _intSelectedLanguage;
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];
	_intSelectedLanguage = [_delegate getSelectedLanguage];
	[_fileActionsViewController localize];
}

- (void)setFileContentDisplayView:(GadgetDisplayController*)fileContentDisplayView
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	[popoverController dismissPopoverAnimated:YES];
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
}

- (void)initRootDirectoryWithUsername:(NSString*)username
{
	if([_strRootDirectory length] == 0)
	{
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		NSString* strHost = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
		NSString* urlStr = [strHost stringByAppendingString:@"/rest/private/jcr/repository/collaboration/Users/"];
		
		urlStr = [urlStr stringByAppendingString:username];
		urlStr = [urlStr stringByAppendingString:@"/Private"];
		_strRootDirectory = [urlStr retain];
		_currenteXoFile = [[eXoFile alloc] initWithUrlStr:_strRootDirectory];
	}
}

- (NSMutableArray*)getPersonalDriveContent:(eXoFile *)file
{
	
	NSString *urlStr = [file._fatherUrlStr stringByAppendingFormat:@"/%@",
								 [file._fileName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
	NSData* dataReply = [[_delegate getConnection] sendRequestWithAuthorization:urlStr];
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
			if(![fileName isEqualToString:@".."])
			{
				eXoFile *fileTmp = [[eXoFile alloc] initWithUrlStr:[urlStr stringByAppendingFormat:@"/%@", fileName]];
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
	
	_currenteXoFile._fileName = [_currenteXoFile._fatherUrlStr lastPathComponent];
	_currenteXoFile._fatherUrlStr = [_currenteXoFile._fatherUrlStr stringByDeletingLastPathComponent];
	_currenteXoFile._fatherUrlStr = [_currenteXoFile._fatherUrlStr stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	
	[self getPersonalDriveContent:_currenteXoFile];
	[_tbvFiles reloadData];
	
	if(_currenteXoFile._isFolder)
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

- (NSString *)urlForFileAction:(eXoFile *)file
{
	if(file._isFolder)
		return [file._fatherUrlStr stringByAppendingFormat:@"/%@", file._fileName];
	
	return [file._fatherUrlStr stringByAppendingFormat:@"/%@", 
			[file._fileName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	NSString* tmpStr = @"";
//	return tmpStr;
//}

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
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
	
	eXoFile *file = [_arrDicts objectAtIndex:indexPath.row];
	
	cell.textLabel.font = [UIFont systemFontOfSize:17.0];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
	[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
	
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 5.0, 400.0, 30.0)];
	titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
	titleLabel.text = file._fileName;
	[cell addSubview:titleLabel];
	
	UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 34.0, 34.0)];
	
	if(file._isFolder)
	{
		imgV.image = [UIImage imageNamed:@"folder.png"];
	}
	else
	{		
		imgV.image = [UIImage imageNamed:fileType(file._fileName)];
	}
	
		[cell addSubview:imgV];
	
	[titleLabel release];
	[imgV release];
	
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
	if(!_fileForDeleteRename._isFolder)
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
	
	eXoFile *file = [_arrDicts objectAtIndex:indexPath.row];
	_currenteXoFile = file;
	
	if(file._isFolder)
	{
	NSThread* startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	[startThread start];
	
		[self getPersonalDriveContent:file];
		[_navigationBar setLeftBarButtonItem:_bbtnBack];
		[_tbvFiles reloadData];
		
		[startThread release];
		[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
	}
	else
	{	
		[_navigationBar setRightBarButtonItem:nil];
		[[_fileContentDisplayController view] setFrame:[_tbvFiles frame]];
		NSURL *tmpURL = [NSURL URLWithString:[file._fatherUrlStr stringByAppendingFormat:@"/%@",
										   [file._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
		
		[_fileContentDisplayController startDisplayFileContent:tmpURL];
		[[self view] addSubview:[_fileContentDisplayController view]];
		
		[_navigationBar setTitle:_currenteXoFile._fileName];
		[_navigationBar setLeftBarButtonItem:_bbtnBack];
	}
	

}


#pragma mark

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
	NSString *tmpStr = _currenteXoFile._fileName;
	if([tmpStr isEqualToString:@"Private"])
	{
		[_navigationBar setTitle:@"Files Application"];
		[_navigationBar setLeftBarButtonItem:nil];
		//[_navigationBar setRightBarButtonItem:_bbtnActions];
	}
	else
	{
		[_navigationBar setTitle:tmpStr];
		[_navigationBar setLeftBarButtonItem:_bbtnBack];
	}	
	[pool release];
}

- (void)onAction:(NSString*)strAction
{
	if([strAction isEqualToString:@"DELETE"] == YES)
	{
		[self doAction:@"DELETE" source:[self urlForFileAction:_fileForDeleteRename] destination:nil];
	}
	else if([strAction isEqualToString:@"NEWFOLDER"] == YES)
	{
		_bNewFolder = YES;
		
		[popoverController dismissPopoverAnimated:YES];
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
		[popoverController dismissPopoverAnimated:YES];
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
		NSString *strSource = [_fileForCopyMove._fatherUrlStr stringByAppendingFormat:@"/%@", _fileForCopyMove._fileName];
		NSString *strDestination = [_fileForDeleteRename._fatherUrlStr stringByAppendingFormat:@"/%@/%@", 
									_fileForDeleteRename._fileName, _fileForCopyMove._fileName];
		
		if(_bCopy)
		{
			[self doAction:@"COPY" source:strDestination destination:strSource];
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
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:[NSURL URLWithString:[strSource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]; 
	
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
		[request setHTTPMethod:@"PUT"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
		NSData* dataFile = [[_delegate getConnection] sendRequestWithAuthorization:strDes];
		[request setHTTPBody:dataFile];
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
						 [NSString stringWithFormat:@"%@:%@", 
						  [[_delegate getConnection] _strUsername], 
						  [[_delegate getConnection] _strPassword]]]];
	
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
				eXoFile *file = [[_arrDicts objectAtIndex:i] retain];
				if([strName isEqualToString:file._fileName])
				{
					bExist = YES;
					
					if(_intSelectedLanguage == 0)
					{
						tmpStr = [NSString stringWithFormat:@"This name \"%@\" is already taken! Please choose a different name", strName];
					}
					else 
					{
						tmpStr = [NSString stringWithFormat:@"Le nom \"%@\" est déjà utilisé. Veuillez entrer un autre nom", strName];
					}

					alert = [[UIAlertView alloc] 
							 initWithTitle:[_dictLocalize objectForKey:@"Info Message"] 
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
				if(!_currenteXoFile._isFolder)
					strName = [strName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
				NSString* strNewFolderPath = [_currenteXoFile._fatherUrlStr stringByAppendingFormat:@"/%@/%@", 
											  [_currenteXoFile._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"], 
											  strName];
				[self doAction:@"MKCOL" source: strNewFolderPath destination:@""];				
			}
		}
		else 
		{
			if(_intSelectedLanguage == 0)
			{
				tmpStr = @"The new name is empty! Please input a valid name";
			}
			else 
			{
				tmpStr = @"Le nom du fichier ne peut pas etre vide. Veuillez entrer un nom valide";
			}
			
			alert = [[UIAlertView alloc] 
					 initWithTitle:[_dictLocalize objectForKey:@"Info Message"] 
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
				eXoFile *file = [[_arrDicts objectAtIndex:i] retain];
				if([strName isEqualToString:file._fileName])
				{
					bExist = YES;
					if(_intSelectedLanguage == 0)
					{
						tmpStr = [NSString stringWithFormat:@"This name \"%@\" is already taken! Please choose a different name", strName];
					}
					else 
					{
						tmpStr = [NSString stringWithFormat:@"Le nom \"%@\" est déjà utilisé. Veuillez entrer un autre nom", strName];
					}
					
					alert = [[UIAlertView alloc] 
							 initWithTitle:[_dictLocalize objectForKey:@"Info Message"] 
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
				if(!_currenteXoFile._isFolder)
					strName = [strName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
					
				NSString* strRenamePath = [_currenteXoFile._fatherUrlStr stringByAppendingFormat:@"/%@/%@", 
											  [_currenteXoFile._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"], 
											  strName];
				NSString *strSource = [_fileForDeleteRename._fatherUrlStr stringByAppendingFormat:@"/%@", _fileForDeleteRename._fileName];
				[self doAction:@"MOVE" source:strSource destination:strRenamePath];
			}
		}
		else 
		{
			if(_intSelectedLanguage == 0)
			{
				tmpStr = @"The new name is empty! Please input a valid name";
		}
		else 
		{
				tmpStr = @"Le nom du fichier ne peut pas etre vide. Veuillez entrer un nom valide";
			}
			
			UIAlertView *alert = [[UIAlertView alloc] 
								  initWithTitle:[_dictLocalize objectForKey:@"Info Message"] 
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
}
@end
