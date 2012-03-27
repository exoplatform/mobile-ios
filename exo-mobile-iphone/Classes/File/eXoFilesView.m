//
//  eXoFilesView.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "eXoFilesView.h"
#import "eXoApplicationsViewController.h"
#import "DataProcess.h"
#import "httpClient.h"
#import "eXoAccount.h"
#import "eXoWebViewController.h"
#import "eXoFileAction.h"
#import "eXoFileActionView.h"


NSString *fileType(NSString *fileName)
{	
	if([fileName length] < 5)
		return @"unknownFileIcon.png";
	else
	{
		NSRange range = NSMakeRange([fileName length] - 4, 4);
		NSString *tmp = [fileName substringWithRange:range];
		tmp = [tmp lowercaseString];
		
		if([tmp isEqualToString:@".png"] || [tmp isEqualToString:@".jpg"] || [tmp isEqualToString:@".jpeg"] || 
		   [tmp isEqualToString:@".gif"] || [tmp isEqualToString:@".psd"] || [tmp isEqualToString:@".tiff"] ||
		   [tmp isEqualToString:@".bmp"] || [tmp isEqualToString:@".pict"])
		{	
			return @"image.png";
		}	
		if([tmp isEqualToString:@".rtf"] || [tmp isEqualToString:@".rtfd"] || [tmp isEqualToString:@".txt"])
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

static NSString *kCellIdentifier = @"MyIdentifier";

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation eXoFile

@synthesize _fileName, _fatherUrlStr, _contentType, _isFolder;

-(BOOL)isFolder:(NSString *)urlStr
{
	_contentType = [[NSString alloc] initWithString:@""];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	BOOL returnValue = FALSE;
	
	NSURL* url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:url];
	[request setTimeoutInterval:60.0];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	
	[request setHTTPMethod:@"PROPFIND"];
	
	[request setHTTPBody: [[NSString stringWithString: @"<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:propfind xmlns:D=\"DAV:\">"
							"<D:prop><D:getcontenttype/></D:prop></D:propfind>"] dataUsingEncoding:NSUTF8StringEncoding]]; 
	
	[request setValue:[httpClient stringOfAuthorizationHeaderWithUsername:username password:password] forHTTPHeaderField:@"Authorization"];
	
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

@implementation eXoFilesView

@synthesize _tblvFilesGrp, _arrDicts, _fileActionViewShape;


- (void)setDriverContent:(NSMutableArray*)arrDriveContent withDelegate:(id)delegate
{
	_arrDicts = [[NSMutableArray alloc] init];
	[_arrDicts removeAllObjects];
	_arrDicts = arrDriveContent;
	_delegate = delegate;
	_delegate.navigationItem.title = _delegate._currenteXoFile._fileName;
	[_tblvFilesGrp setEditing:NO];
	[_tblvFilesGrp reloadData];
	
	//NSString *tmpStr = _delegate._currenteXoFile._fileName; 

	_delegate.navigationItem.rightBarButtonItem = _delegate._btnFileAcion;
	//if(![tmpStr isEqualToString:@"Private"])
//	{
//		_delegate.navigationItem.rightBarButtonItem = _delegate._btnFileAcion;
//	}
	
}

-(void) onFileActionbtn
{
	if(_fileActionViewShape == nil)
	{
		_fileActionViewShape = [[eXoFileActionView alloc] initWithFrame:CGRectMake(45, 10, 240, 350)];
		_fileActionViewShape.backgroundColor = [UIColor clearColor];
	}
	
	[_delegate.view addSubview:_fileActionViewShape];	
	
	_tblvFilesGrp.userInteractionEnabled = NO;
	_delegate.navigationController.navigationBar.userInteractionEnabled = NO;
	_delegate.tabBarController.tabBar.userInteractionEnabled = NO;
	
	eXoFileAction *fileAction = [[eXoFileAction alloc] initWithNibName:@"eXoFileAction" bundle:nil delegate:_delegate filesView:self file:_delegate._currenteXoFile enableDeleteThisFolder:NO];
	fileAction.view.frame = CGRectMake(50, 60, 230, 270);
	[_delegate.view addSubview:fileAction.view];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	NSDictionary* tmpDict = [_arrDicts objectAtIndex:section];	
//	return [[tmpDict allKeys] objectAtIndex:0];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_arrDicts count];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{

	//[_tblvFilesGrp setEditing:editing animated:animated];
		
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	//if (editingStyle == UITableViewCellEditingStyleDelete) {
//		
//		
//		eXoFile *file = [_arrDicts objectAtIndex:indexPath.row];
//		NSString *deleteFile = [NSString stringWithString:[file._fatherUrlStr stringByAppendingFormat:@"/%@", 
//														   [file._fileName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
//		
//		[_delegate fileAction:@"DELETE" source:deleteFile destination:nil data:nil];
//		
//		
//		[_tblvFilesGrp setEditing:NO animated:YES];
//				
//		_delegate.navigationItem.leftBarButtonItem.enabled = YES;
//		
//	}
//	if (editingStyle == UITableViewCellEditingStyleInsert) {
//	}
//	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
	
	eXoFile *file = [_arrDicts objectAtIndex:indexPath.row];
	
	UIImageView* imgViewFile = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 40, 40)];
	if(file._isFolder)
		imgViewFile.image = [UIImage imageNamed:@"folder.png"];
	else
		imgViewFile.image = [UIImage imageNamed:fileType(file._fileName)];
	[cell addSubview:imgViewFile];
	
	
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 200.0, 20.0)];
	titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	NSString* tmpStr = file._fileName;
	tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
	titleLabel.text = tmpStr;
	[cell addSubview:titleLabel];
	
	
	UIButton *btnFileAction = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 9, 30, 30)];
	[btnFileAction setBackgroundImage:[UIImage imageNamed:@"action.png"] forState:UIControlStateNormal];
	[btnFileAction addTarget:self action:@selector(fileAction:) forControlEvents:UIControlEventTouchUpInside];
	btnFileAction.tag = indexPath.row;
	[cell addSubview:btnFileAction];

	
	return cell;
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	[startThread start];
	
	
	eXoFile *file = [_arrDicts objectAtIndex:indexPath.row];
	
	if(file._isFolder)
	{
		_delegate._currenteXoFile = file;
		_arrDicts = [_delegate getPersonalDriveContent:file];
		
		[self setDriverContent:_arrDicts withDelegate:_delegate];
		_delegate.navigationItem.leftBarButtonItem = _delegate._btnBack;
		
	}else
	{
		
		NSURL *url = [NSURL URLWithString:[file._fatherUrlStr stringByAppendingFormat:@"/%@",
										   [file._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
		eXoWebViewController* tmpView = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController" bundle:nil url:url];
		tmpView._delegate = _delegate;
		[[_delegate navigationController] pushViewController:tmpView animated:YES];
		
	}
	
	[startThread release];
	[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];

}

-(void)startInProgress {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UIBarButtonItem* progressBtn = [[UIBarButtonItem alloc] initWithCustomView:_delegate._indicator];
	_delegate.navigationItem.leftBarButtonItem = progressBtn;
	_delegate.navigationItem.rightBarButtonItem = nil;
	[pool release];
	
}

-(void)endProgress
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *tmpStr = _delegate._currenteXoFile._fileName;
	
	//_delegate.navigationItem.leftBarButtonItem = nil;
	if([tmpStr isEqualToString:@"Private"])
	{
		[_delegate addCloseBtn];
	}
	else
	{
		[_delegate._btnBack setTitle:[_delegate._dictLocalize objectForKey:@"BackButton"]];
		_delegate.navigationItem.leftBarButtonItem = _delegate._btnBack;
	}
	
	[pool release];
}

- (void)fileAction:(UIButton *)sender
{
	if(_fileActionViewShape == nil)
	{
		_fileActionViewShape = [[eXoFileActionView alloc] initWithFrame:CGRectMake(45, 10, 240, 350)];
		_fileActionViewShape.backgroundColor = [UIColor clearColor];
	}
	
	[_delegate.view addSubview:_fileActionViewShape];	
	
	eXoFile *file = [_arrDicts objectAtIndex:sender.tag];
	_tblvFilesGrp.userInteractionEnabled = NO;
	_delegate.navigationController.navigationBar.userInteractionEnabled = NO;
	_delegate.tabBarController.tabBar.userInteractionEnabled = NO;
	
	[_delegate._fileAction release];
	_delegate._fileAction = nil;
	_delegate._fileAction = [[eXoFileAction alloc] initWithNibName:@"eXoFileAction" bundle:nil delegate:_delegate filesView:self file:file enableDeleteThisFolder:YES];
	_delegate._fileAction.view.frame = CGRectMake(50, 60, 230, 270);
	[_delegate.view addSubview:_delegate._fileAction.view];
	
}

@end
