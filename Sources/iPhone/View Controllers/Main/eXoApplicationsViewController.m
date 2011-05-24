//
//  eXoApplicationsViewController.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/1/09.
//  Copyright 2009 home. All rights reserved.
//

#import "eXoApplicationsViewController.h"
#import "AppDelegate_iPhone.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "DataProcess.h"
#import "eXoFilesView.h"
#import "Connection.h"
#import "AuthenticateViewController.h"
#import "eXoChatView.h"
#import "eXoChatWindow.h"
#import "XMPPStream.h"
#import "XMPPClient.h"
#import "XMPPUser.h"
#import "XMPPJID.h"
#import "XMPPMessage.h"

#import "CXMLNode.h"
#import "CXMLElement.h"
#import "CXMLDocument.h"

#import "eXoMessage.h"
#import "eXoWebViewController.h"
#import "DDXML.h"
#import "Gadget_iPhone.h"
#import "eXoGadgetViewController.h"
#import "eXoFileActionViewController.h"






static NSString *kCellIdentifier = @"MyIdentifier";
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333

//--------------------------------------------
@implementation eXoChatUser
- (void)setObjectWithXMPPUser:(XMPPUser*)xmppUser andArrMsg:(NSMutableArray*)arrMessages andHtmlstr:(NSString*)htmlStr
{
	_xmppUser = xmppUser;
	_arrMessages = arrMessages;
	_htmlStr = htmlStr;
}

- (XMPPUser*)getXmppUser
{
	return _xmppUser;
}

- (NSString*)getChatUserId
{
	return [[_xmppUser jid] user];
}

- (NSMutableArray*)getArrMessages
{
	return _arrMessages;
}

- (void)setArrMessages:(NSMutableArray*)arrMessages
{
	_arrMessages = arrMessages;
}

- (NSString*)getHtmlStr {
	return _htmlStr;
}

- (void)setHtmlStr:(NSString*)htmlStr {
	_htmlStr = [htmlStr retain];
}

@end

//--------------------------------------------
@implementation eXoApplicationsViewController

@synthesize _newsView, _chatView, _chatWindow, _fileAction;
//@synthesize _filesView, _newsView, _chatView, _chatWindow, _fileAction;
@synthesize _xmppStream, _currentChatUser, _isNewMsg;
@synthesize _arrDicts, _arrChatUsers, _arrGadgets;
//@synthesize _currenteXoFile, _fileNameStackStr;
@synthesize _fileNameStackStr;
@synthesize _btnSignOut, _btnBack, _btnFileAcion, _btnChatViewBack, _btnChatSend, _btnClearMsg, _bBackFromGadgets;
@synthesize _indicator;
@synthesize _dictLocalize;
@synthesize _btnNotificationRecievedMessage, _selectedLanguage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		// self.title = @"Applications";
		_arrDicts = [[NSMutableArray alloc] init];
		_arrChatUsers = [[NSMutableArray alloc] init];
		_arrGadgets = [[NSMutableArray alloc] init]; 
		_xmppStream = [[XMPPStream alloc] init];
		[_xmppStream setDelegate:self];
		_selectedLanguage = 0;
		_bFilesChatEnterred = NO;
		_isNewMsg = FALSE;
		
		//_filesView = [[eXoFilesView alloc] init];
		
		_btnSignOut = [[UIBarButtonItem alloc] initWithTitle:@"Sign out" style:UIBarButtonItemStylePlain
													 target:self action:@selector(onSignOutBtn)];
		
		_btnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain 
												   target:self action:@selector(onBackBtn)];

		_btnFileAcion = [[UIBarButtonItem alloc] initWithTitle:@"Action" style:UIBarButtonItemStylePlain 
														target:self action:@selector(onFileActionBtn)];
		_btnFileAcion.tag = -1;

		_btnChatViewBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain 
												   target:self action:@selector(onChatViewBackBtn)];
		
		_btnChatSend = [[UIButton alloc] initWithFrame:CGRectMake(252, 331, 65, 24)];
		[_btnChatSend addTarget:self action:@selector(onChatSendBtn) forControlEvents:UIControlEventTouchUpInside];
		[_btnChatSend.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];

														  		
		_btnClearMsg = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain 
													   target:self action:@selector(onChatClearBtn)];

		
		_btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop 
																target:self action:@selector(onCloseBtn)];	
		
		_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
		[_indicator startAnimating];
		_indicator.hidesWhenStopped = YES;
		
		_btnNotificationRecievedMessage = [[UIButton alloc] initWithFrame:CGRectMake(120, 430, 30, 30)];
		[_btnNotificationRecievedMessage setBackgroundImage:[UIImage imageNamed:@"newmessage.png"] forState:UIControlStateNormal];
		_btnNotificationRecievedMessage.userInteractionEnabled = NO;
		_btnNotificationRecievedMessage.hidden = YES;
		
		_conn = [[Connection alloc] init];
    }
    return self;
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)loadView 
{
	[super loadView];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	//if(_currenteXoFile != nil)
	
	
	[_btnBack setTitle:[_dictLocalize objectForKey:@"BackButton"]];
	[_btnFileAcion setTitle:[_dictLocalize objectForKey:@"ActionButton"]];
	[_btnChatViewBack setTitle:[_dictLocalize objectForKey:@"BackButton"]];
	[_btnChatSend setTitle:[_dictLocalize objectForKey:@"Send"] forState:UIControlStateNormal];
	[_btnClearMsg setTitle:[_dictLocalize objectForKey:@"Clear"]];
	[_btnSignOut setTitle:[_dictLocalize objectForKey:@"SignOutButton"]];
	
	//_filesView.labelEmptyPage.text = [_dictLocalize objectForKey:@"EmptyPage"];
	
	if(!_bFilesChatEnterred)
	{
		self.title = [_dictLocalize objectForKey:@"ApplicationsTitle"];
	}	
	
	[_tblvGadgetsGrp reloadData];
}

- (NSDictionary*)getDictLocalize
{
	return _dictLocalize;
}

- (void)viewDidLoad 
{
	
	[_arrGadgets removeAllObjects];
	_arrGadgets = [[_conn getItemsInDashboard] retain];	
	
	[super viewDidLoad];	
}

-(void)onSignOutBtn
{
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:@"NO" forKey:EXO_AUTO_LOGIN];
	
	NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *tmpArr = [store cookies];
	for(int i = 0; i < [tmpArr count]; i++)
		[store deleteCookie:[tmpArr objectAtIndex:i]];
	
	if(_xmppClient != nil && [_xmppClient isAuthenticated])
	{
		[_xmppClient disconnect];
	}
	
	AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone*)[[UIApplication sharedApplication] delegate];
	[appDelegate.tabBarController.view removeFromSuperview];
	[appDelegate.authenticateViewController loadView];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)setSelectedLanguage:(int)sel
{
	_selectedLanguage = sel;
	NSString* filePath;
	if(_selectedLanguage == 0)
	{
		filePath = [[NSBundle mainBundle] pathForResource:@"Localize_EN" ofType:@"xml"];
	}	
	else
	{	
		filePath = [[NSBundle mainBundle] pathForResource:@"Localize_FR" ofType:@"xml"];
	}	
	
	[_dictLocalize release];
	_dictLocalize = nil;
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:filePath];	
}

- (void)viewDidUnload 
{

}

- (void)viewDidAppear:(BOOL)animated
{
	
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	//[_fileAction.view removeFromSuperview];
	//[_filesView._fileActionViewShape removeFromSuperview];
	//_filesView._tblvFilesGrp.userInteractionEnabled = YES;

}

- (void)dealloc 
{
    [super dealloc];
}

- (id)getAppDelegate
{
	UIApplication* app = [UIApplication sharedApplication];
	id appDelegate = [app delegate];
	return appDelegate;
}

- (void)addCloseBtn
{
	//if(!_btnClose)
	//{	
        _btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(onCloseBtn)];	
    //}
	[[self navigationItem] setLeftBarButtonItem:_btnClose];		
}

-(void)onCancelCopy
{
	//[self._currenteXoFile release];
	//self._currenteXoFile = nil;
	[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)onSelectCopy
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)onCloseCopy
{
	[self dismissModalViewControllerAnimated:YES];	
}

- (IBAction)onFilesBtn
{

	[self addCloseBtn];
	//process to get info from personal_drive
	//[_arrDicts removeAllObjects];
	//_arrDicts = [self getPersonalDriveContent:self._currenteXoFile];
	//[_filesView setDriverContent:_arrDicts withDelegate:self];
}

//- (IBAction)onNewsBtn
//{
//	[self addCloseBtn];
//	[[self view] addSubview:_newsView];
//	_tempView = _newsView;
//	
//}

- (IBAction)onChatBtn
{
	[self navigationItem].title = @"Chat";
	self.navigationItem.rightBarButtonItem = nil;
	[ _chatWindow removeFromSuperview];
	[[self view] addSubview:_chatView];
	_tempView = _chatView;
}

- (IBAction)onCloseBtn
{
	[_tempView removeFromSuperview];
	
	self.navigationItem.rightBarButtonItem = _btnSignOut;
	self.navigationItem.leftBarButtonItem = nil;
	[self setSelectedLanguage:_selectedLanguage];
	[[self navigationItem] setTitle:[_dictLocalize objectForKey:@"ApplicationsTitle"]];
	self.title = [_dictLocalize objectForKey:@"ApplicationsTitle"];
	[_tblvGadgetsGrp reloadData];
	
	
}

- (void)onFileActionBtn
{
	//[_filesView onFileActionbtn];
}

-(void)fileAction:(NSString *)protocol source:(NSString *)source destination:(NSString *)destination data:(NSData *)data
{	
	source = [DataProcess encodeUrl:source];
	destination = [DataProcess encodeUrl:destination];
	
	NSRange range;
	range = [source rangeOfString:@"http://"];
	if(range.length == 0)
		source = [source stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	range = [destination rangeOfString:@"http://"];
	if(range.length == 0)
		destination = [destination stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	NSHTTPURLResponse* response;
	NSError* error;
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:[NSURL URLWithString:source]]; 
	
	if([protocol isEqualToString:@"DELETE"])
	{
		[request setHTTPMethod:@"DELETE"];
		
	}else if([protocol isEqualToString:@"UPLOAD"])
	{
		[request setHTTPMethod:@"PUT"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
		[request setHTTPBody:data];
		
	}
	else if([protocol isEqualToString:@"COPY"])
	{
		[request setHTTPMethod:@"COPY"];
		[request setValue:destination forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];

	}else
	{
		[request setHTTPMethod:@"MOVE"];
		[request setValue:destination forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
		
		if([source isEqualToString:destination]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cut file" message:@"Can not move file to its location" delegate:self 
												  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
			
            [request release];
            
			return;
		}
	}
	
	NSString *s = @"Basic ";
    NSString *author = [s stringByAppendingString: [_conn stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];
	[request setValue:author forHTTPHeaderField:@"Authorization"];
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [request release];
    
	NSUInteger statusCode = [response statusCode];
	if(!(statusCode >= 200 && statusCode < 300))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %d!", statusCode] message:@"Can not transfer file" delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
	//_arrDicts = [self getPersonalDriveContent:_currenteXoFile];
	//[_filesView setDriverContent:_arrDicts withDelegate:self];
}

- (void)setChatClient:(XMPPClient*)xmppClient
{
	_xmppClient = xmppClient;
}

- (void)setChatUsers:(NSArray*)arrUsers
{
	for(int i = 0; i < [arrUsers count]; i++)
	{
		eXoChatUser* chatUser = [[eXoChatUser alloc] init];
		NSMutableArray* arrMessages = [[NSMutableArray alloc] init];
		NSString* htmlStr = [[NSString alloc] init];
		[chatUser setObjectWithXMPPUser:[arrUsers objectAtIndex:i] andArrMsg:arrMessages  andHtmlstr:htmlStr];
		[_arrChatUsers addObject:chatUser]; 
        
        [chatUser release];
        [htmlStr release];
        [arrMessages release];
	}
	 
}

- (void)showChatWindowWithXMPPUser:(XMPPUser*)xmppUser listMsg:(NSMutableDictionary *)listMsg
{	
	[[self navigationItem] setTitle:[[xmppUser jid] user]];
	
	for (int i = 0; i < [_arrChatUsers count]; i++)
	{
		if([[_arrChatUsers objectAtIndex:i] getChatUserId] == [[xmppUser jid] user])
		{
				
			[ _chatWindow initChatWindowWithDelegate:self andXMPPClient:_xmppClient andExoChatUser:[_arrChatUsers objectAtIndex:i]  listMsg:listMsg];
			_chatWindow._arrChatUsers = self._arrChatUsers;
			
			[[self navigationItem] setLeftBarButtonItem:_btnChatViewBack];
			[[self view] addSubview: _chatWindow];
			_tempView =  _chatWindow;
			[_chatView removeFromSuperview];
			break;
		}
	}
}

- (void)updateForEachExoChatUser:(XMPPUser*)xmppUser withArrMsg:(NSMutableArray*)arrMsg  withHtmlStr:(NSString*)htmlStr
{
	for (int i = 0; i < [_arrChatUsers count]; i++)
	{
		if([[_arrChatUsers objectAtIndex:i] getChatUserId] == [[xmppUser jid] user])
		{
			[[_arrChatUsers objectAtIndex:i] setArrMessages:arrMsg];
			[[_arrChatUsers objectAtIndex:i] setHtmlStr:htmlStr];
			
		}
	}	
}

- (void)receivedChatMsg:(XMPPMessage*)message listMsg:(NSMutableDictionary *)listMsg
{
	[ _chatWindow receivedChatMsg:message listMsg:listMsg];
}

- (IBAction)onChatViewBackBtn
{
	[[self navigationItem] setLeftBarButtonItem:_btnClose];
	[[self navigationItem] setRightBarButtonItem:nil];	
	[_chatWindow backToChatList];
	[ _chatWindow removeFromSuperview];
	[[self view] addSubview:_chatView];
	_tempView = _chatView;
}
		
-(void)onChatClearBtn
{
	[_chatWindow onClearBtn];
}
		
-(void)onChatSendBtn
{
	[_chatWindow onBtnSendMsg];
}

/*
- (NSMutableArray*)getPersonalDriveContent:(eXoFile_iPhone *)file
{
	
	NSData* dataReply = [_conn sendRequestWithAuthorization:file._urlStr];
	NSString* strData = [[[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding] autorelease];
	
	NSMutableArray* arrDicts = [[NSMutableArray alloc] init];
	[arrDicts removeAllObjects];
	
	NSRange range1;
	NSRange range2;
	do 
	{
		range1 = [strData rangeOfString:@"alt=\"\"> "];
		range2 = [strData rangeOfString:@"</a>"];
		
		if(range1.length > 0)
		{
			NSString *fileName = [strData substringWithRange:NSMakeRange(range1.length + range1.location, 
																		 range2.location - range1.location - range1.length)];
			fileName = [fileName stringByDecodingHTMLEntities];
			if(![fileName isEqualToString:@".."])
			{
				NSRange range3 = [strData rangeOfString:@"<a href=\""];
				NSRange range4 = [strData rangeOfString:@"\"><img src"];
				NSString *urlStr = [strData substringWithRange:NSMakeRange(range3.length + range3.location, 
																		   range4.location - range3.location - range3.length)];
				eXoFile_iPhone *file2 = [[eXoFile_iPhone alloc] initWithUrlStr:urlStr fileName:fileName];
				[arrDicts addObject:file2];
                [file2 release];
			}

		}
		if(range2.length > 0)
			strData = [strData substringFromIndex:range2.location + range2.length];
	} while (range1.length > 0);
	
    
	return arrDicts;
}
*/
- (IBAction)onBackBtn
{

	startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	[startThread start];
	
	_fileNameStackStr = [[_fileNameStackStr stringByDeletingLastPathComponent] retain];
	
	//_currenteXoFile._fileName = [_fileNameStackStr lastPathComponent];
	//_currenteXoFile._urlStr = [_currenteXoFile._urlStr stringByDeletingLastPathComponent];
	//_currenteXoFile._urlStr = [_currenteXoFile._urlStr stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	
	//_arrDicts = [self getPersonalDriveContent:self._currenteXoFile];
	
	//[_filesView setDriverContent:_arrDicts withDelegate:self];
	
	[startThread release];
	
	[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
}

-(void)onDoneCopy 
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)startInProgress {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UIBarButtonItem* progressBtn = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
	[[self navigationItem] setLeftBarButtonItem:progressBtn];
	self.navigationItem.rightBarButtonItem = nil;
	[pool release];
	
}

-(void)endProgress
{
	/*NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *tmpStr = _currenteXoFile._urlStr;
	NSString *domainStr = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN];
	
	if(_bBackFromGadgets)
		self.navigationItem.leftBarButtonItem = nil;
	else if([tmpStr isEqualToString:[domainStr stringByAppendingFormat:@"/rest/private/jcr/repository/collaboration/Users/%@",
									 [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME]]])
	{
		[self addCloseBtn];
	}
	else
	{
		[[self navigationItem] setLeftBarButtonItem:_btnBack];
	}
	
	if(_bBackFromGadgets)
		self.navigationItem.rightBarButtonItem = _btnSignOut;

	[pool release];
     */
}

-(void)endProgressForChat
{
	self.navigationItem.leftBarButtonItem = nil;
	if(_bBackFromGadgets)
	{
		self.navigationItem.rightBarButtonItem = _btnSignOut;
	}else
	{
		self.navigationItem.leftBarButtonItem = _btnClose;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	if(section == 0)
	{
		tmpStr = [_dictLocalize objectForKey:@"NativeApplicationsHeader"];
	}
	else if(section == 1)
	{
		if([_arrGadgets count] > 0)
			tmpStr = [_dictLocalize objectForKey:@"GadgetsHeader"];
	}	
	return tmpStr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int n = 0;
	if(section == 0)
	{
		n = 2;
	}
	else if(section == 1)
	{
		n = [_arrGadgets count];
		
	}	
	return n;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
            
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 20.0, 210.0, 20.0)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        titleLabel.tag = kTagForCellSubviewTitleLabel;
        [cell addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
        imgV.tag = kTagForCellSubviewImageView;
        [cell addSubview:imgV];
        [imgV release];
        
    }
	
    UILabel* titleLabel = (UILabel *)[cell viewWithTag:kTagForCellSubviewTitleLabel];
    UIImageView* imgView = (UIImageView *)[cell viewWithTag:kTagForCellSubviewImageView];
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            titleLabel.text = @"Chat";		
            if(_xmppClient != nil && [_xmppClient isConnected] && [_xmppClient isAuthenticated])
                imgView.image = [UIImage imageNamed:@"onlineicon.png"];
            else
                imgView.image = [UIImage imageNamed:@"offlineicon.png"];
        }
        else if(indexPath.row == 1)
        {
            titleLabel.text = @"Files";
            imgView.image = [UIImage imageNamed:@"filesApp.png"];
            
        }
        else
        {
            titleLabel.text = @"eXoActivity";					
            imgView.image = [UIImage imageNamed:@"ActivityIcon.png"];
        }
    } else {
        
        imgView.image = [UIImage imageNamed:@"Dashboard.png"];
        GateInDbItem_iPhone *gadgetTab = [_arrGadgets objectAtIndex:indexPath.row];
        titleLabel.text = gadgetTab._strDbItemName;
    }
    
	return cell;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	return YES;
}

-(void)createFileView
{
    /*
	if(_currenteXoFile == nil)
	{
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
		NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
		NSString* urlStr = [domain stringByAppendingString:@"/rest/private/jcr/repository/collaboration/Users/"];
		_fileNameStackStr = username;
		urlStr = [urlStr stringByAppendingString:username];
		//urlStr = [urlStr stringByAppendingString:@"/Private"];
		
		_currenteXoFile = [[eXoFile_iPhone alloc] initWithUrlStr:urlStr fileName:username];
	}
	*/
    /*
	if(!_filesView)
	{
		_filesView = [[eXoFilesView alloc] init];
	}
	*/
	//[[self view] addSubview:_filesView];
	//_tempView = _filesView;
	
	[self onFilesBtn];
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) 
	{
		case 0:
		{
			if(!_indicator)
			{
				_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
				[_indicator startAnimating];
			}
			
			startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
			[startThread start];
			
			_bBackFromGadgets = NO;
			_bFilesChatEnterred = YES;
			
			if(indexPath.row == 0)
			{
				_currentChatUser = [NSString stringWithString:@""];
				[_chatView initForChatWithDelegate:self];
				[self navigationItem].title = @"Chat";
				self.navigationItem.rightBarButtonItem = nil;
				[ _chatWindow removeFromSuperview];
				[[self view] addSubview:_chatView];
				_tempView = _chatView;
				
				[self performSelectorOnMainThread:@selector(endProgressForChat) withObject:nil waitUntilDone:NO];
			}
			else if(indexPath.row == 1)
			{	
				[self createFileView];
				[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
			}
			else
			{
			}
			
			[startThread cancel];
			
			break;
		}
			
		case 1:
		{
			eXoGadgetViewController *gadgetViewController = [[eXoGadgetViewController alloc] initWithStyle:UITableViewStyleGrouped delegate:self gadgetTab:[_arrGadgets objectAtIndex:indexPath.row]];
			[self.navigationController pushViewController:gadgetViewController animated:YES];
            [gadgetViewController release];
			break;
		}
			
		default:
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
