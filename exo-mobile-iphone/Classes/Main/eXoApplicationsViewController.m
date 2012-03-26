//
//  eXoApplicationsViewController.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/1/09.
//  Copyright 2009 home. All rights reserved.
//

#import "eXoApplicationsViewController.h"
#import "eXoActivityStreamsViewController.h"
#import "eXoAppAppDelegate.h"
#import "defines.h"
#import "DataProcess.h"
#import "eXoFilesView.h"
#import "httpClient.h"
#import "eXoAccount.h"
#import "eXoAppViewController.h"
#import "eXoFilesView.h"
#import "eXoChatView.h"
#import "eXoChatWindow.h"
#import "eXoAppViewController.h"
#import "XMPPStream.h"
#import "XMPPClient.h"
#import "XMPPUser.h"
#import "XMPPJID.h"
#import "XMPPMessage.h"

#import "CXMLNode.h"
#import "CXMLElement.h"
#import "CXMLDocument.h"

#import "eXoIconRepository.h"
#import "eXoMessage.h"
#import "eXoWebViewController.h"
#import "DDXML.h"
#import "Gadget.h"
#import "eXoGadgetViewController.h"
#import "eXoFileAction.h"

static NSString *kCellIdentifier = @"MyIdentifier";

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

@synthesize _filesView, _newsView, _chatView, _chatWindow, _fileAction;
@synthesize _xmppStream, _currentChatUser, _isNewMsg;
@synthesize _arrDicts, _arrChatUsers, _arrGadgets;
@synthesize _currenteXoFile;
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
		
		_filesView = [[eXoFilesView alloc] init];
		
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
	
	//self.title = [_dictLocalize objectForKey:@"ApplicationsTitle"];
//	
//	if(self.navigationItem.rightBarButtonItem == _btnSignOut)
//	{
//		[[self navigationItem] setTitle:[_dictLocalize objectForKey:@"ApplicationsTitle"]];
//		[_btnSignOut setTitle:[_dictLocalize objectForKey:@"SignOutButton"]];
//		self.navigationItem.rightBarButtonItem = _btnSignOut;
//	}
//	
//	[_tblvGadgetsGrp reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
	if(_currenteXoFile != nil)
	{
		//_arrDicts = [self getPersonalDriveContent:_currenteXoFile];
		//[_filesView setDriverContent:_arrDicts withDelegate:self];
	}
	
	[_btnBack setTitle:[_dictLocalize objectForKey:@"BackButton"]];
	[_btnFileAcion setTitle:[_dictLocalize objectForKey:@"ActionButton"]];
	[_btnChatViewBack setTitle:[_dictLocalize objectForKey:@"BackButton"]];
	[_btnChatSend setTitle:[_dictLocalize objectForKey:@"Send"] forState:UIControlStateNormal];
	[_btnClearMsg setTitle:[_dictLocalize objectForKey:@"Clear"]];
	[_btnSignOut setTitle:[_dictLocalize objectForKey:@"SignOutButton"]];
	
	if(!_bFilesChatEnterred)
	{
		self.title = [_dictLocalize objectForKey:@"ApplicationsTitle"];
	}	
	
	//self.navigationItem.rightBarButtonItem = _btnSignOut;
	
	[_tblvGadgetsGrp reloadData];
}

- (NSDictionary*)getDictLocalize
{
	return _dictLocalize;
}

- (void)viewDidLoad 
{
	[_arrGadgets removeAllObjects];
	_arrGadgets = [[eXoApplicationsViewController listOfGadgets] retain];	
	
	[super viewDidLoad];	
	//_tblvGadgetsGrp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableViewBg.png"]];	
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
	
	eXoAppAppDelegate *appDelegate = (eXoAppAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate.tabBarController.view removeFromSuperview];
	[appDelegate.viewController loadView];

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
		filePath = [[[NSBundle mainBundle] pathForResource:@"LocalizeEN" ofType:@"xml"] retain];
	}	
	else
	{	
		filePath = [[[NSBundle mainBundle] pathForResource:@"LocalizeFR" ofType:@"xml"] retain];
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
	//if(_bFilesEnterred)
//	{	
//		if(_markParent)
//		{	
//			[self displayFolderContent:_markParent];
//		}	
//	}	
//	else
//	{
//		[_tblvGadgetsGrp reloadData];
//	}
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[_fileAction.view removeFromSuperview];
	[_filesView._fileActionViewShape removeFromSuperview];
	_filesView._tblvFilesGrp.userInteractionEnabled = YES;

}


- (void)dealloc 
{
    [super dealloc];
}

+(NSString *)getStringForGadget:(NSString *)gadgetStr startStr:(NSString *)startStr endStr:(NSString *)endStr
{
	NSString *returnValue = @"";
	NSRange range1;
	NSRange range2;
	
	range1 = [gadgetStr rangeOfString:startStr];
	
	if(range1.length > 0)
	{
		NSString *tmpStr = [gadgetStr substringFromIndex:range1.location + range1.length];
		range2 = [tmpStr rangeOfString:endStr];
		if(range2.length > 0)
			returnValue = [tmpStr substringToIndex:range2.location];
	}
		
	return returnValue;
}

+ (NSArray*)listOfGadgetsWithURL:(NSString *)url
{
	NSMutableArray* arrTmpGadgets = [[NSMutableArray alloc] init];
	
	NSString* strGadgetName;
	NSString* strGadgetDescription;
	NSURL* urlGadgetContent;
	UIImage* imgGadgetIcon;
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	NSString* userName = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString* password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	NSMutableString* strContent;
	
//	NSRange rangeOfSocial = [domain rangeOfString:@"social"];
//	if (rangeOfSocial.length > 0) 
//	{
//		//dataReply = [[_delegate getConnection] sendRequestToSocialToGetGadget:[url absoluteString]];
//	}
//	else
//	{
//		NSData *data = [httpClient sendRequestToGetGadget:url username:userName password:password];
//		strContent = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	}
	
	NSData *data = [httpClient sendRequestToGetGadget:url username:userName password:password];
	strContent = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSRange range1;
	NSRange range2;
	
	range1 = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];
	if(range1.length <= 0)
		return nil;
	
	do {
		strContent = (NSMutableString *)[strContent substringFromIndex:range1.location + range1.length];
		range2 = [strContent rangeOfString:@"'/eXoGadgetServer/gadgets',"];
		if(range2.length <= 0)
			return nil;
		NSString *tmpStr = [strContent substringToIndex:range2.location + range2.length + 10];
		
		strGadgetName = [eXoApplicationsViewController getStringForGadget:tmpStr startStr:@"\"title\":\"" endStr:@"\","]; 
		strGadgetDescription = [eXoApplicationsViewController getStringForGadget:tmpStr startStr:@"\"description\":\"" endStr:@"\","];
		NSString *gadgetIconUrl = [eXoApplicationsViewController getStringForGadget:tmpStr startStr:@"\"thumbnail\":\"" endStr:@"\","];

		if([gadgetIconUrl isEqualToString:@""])
			imgGadgetIcon = [UIImage imageNamed:@"PortletsIcon.png"];
		else
		{
			imgGadgetIcon = [UIImage imageWithData:[httpClient sendRequest:gadgetIconUrl]];
			if (imgGadgetIcon == nil) 
			{
				NSRange range3 = [gadgetIconUrl rangeOfString:@"://"];
				if(range3.length == 0)
				{
					strContent = (NSMutableString *)[strContent substringFromIndex:range2.location + range2.length];
					range1 = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];
					continue;
				}
				
				gadgetIconUrl = [gadgetIconUrl substringFromIndex:range3.location + range3.length];
				range3 = [gadgetIconUrl rangeOfString:@"/"];
				gadgetIconUrl = [gadgetIconUrl substringFromIndex:range3.location];	
				NSString* tmpGGIC= [NSString stringWithFormat:@"%@%@", domain, gadgetIconUrl];		
				imgGadgetIcon = [UIImage imageWithData:[httpClient sendRequest:tmpGGIC]];
				if (imgGadgetIcon == nil) 
				{
					imgGadgetIcon = [UIImage imageNamed:@"PortletsIcon.png"];
				}
			}
		}
		
		NSMutableString *gadgetUrl = [[NSMutableString alloc] initWithString:@""];
		[gadgetUrl appendString:domain];
		
		[gadgetUrl appendFormat:@"%@/", [eXoApplicationsViewController getStringForGadget:tmpStr startStr:@"'home', '" endStr:@"',"]];
		[gadgetUrl appendFormat:@"ifr?container=default&mid=1&nocache=0&lang=%@&debug=1&st=default", [eXoApplicationsViewController getStringForGadget:tmpStr startStr:@"&lang=" endStr:@"\","]];
		
		NSString *token = [NSString stringWithFormat:@":%@", [eXoApplicationsViewController getStringForGadget:tmpStr startStr:@"\"default:" endStr:@"\","]];
		token = [token stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
		token = [token stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
		token = [token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
		token = [token stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
		
		
		[gadgetUrl appendFormat:@"%@&url=", token];
		
		NSString *gadgetXmlFile = [eXoApplicationsViewController getStringForGadget:tmpStr startStr:@"\"url\":\"" endStr:@"\","];
		gadgetXmlFile = [gadgetXmlFile stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
		gadgetXmlFile = [gadgetXmlFile stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
		
		[gadgetUrl appendFormat:@"%@", gadgetXmlFile];
		
		urlGadgetContent = [NSURL URLWithString:gadgetUrl];
		
		Gadget* gadget = [[Gadget alloc] init];
		
		[gadget setObjectWithName:strGadgetName description:strGadgetDescription urlContent:urlGadgetContent urlIcon:nil imageIcon:imgGadgetIcon];
		[arrTmpGadgets addObject:gadget];

		strContent = (NSMutableString *)[strContent substringFromIndex:range2.location + range2.length];
		range1 = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];

		
	} while (range1.length > 0);
		
		
	return arrTmpGadgets;
}

+ (NSMutableArray*)listOfGadgets
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	
	NSMutableArray* arrTmpGadgets = [[NSMutableArray alloc] init];

	NSString* strContent = [httpClient getFirstLoginContent];

	NSRange range1;
	NSRange range2;
	NSRange range3;
	range1 = [strContent rangeOfString:@"DashboardIcon TBIcon"];
	
	if(range1.length <= 0)
		return nil;
	
	strContent = [strContent substringFromIndex:range1.location + range1.length];
	range1 = [strContent rangeOfString:@"TBIcon"];
	
	if(range1.length <= 0)
		return nil;
	
	strContent = [strContent substringToIndex:range1.location];
	
	
	do {
		range1 = [strContent rangeOfString:@"ItemIcon DefaultPageIcon\" href=\""];
		range2 = [strContent rangeOfString:@"\" >"];
		if(range1.length > 0 && range2.length > 0)
		{				
			NSString *gadgetTabUrlStr = [strContent substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length)];
			NSURL* gadgetTabUrl = [NSURL URLWithString:gadgetTabUrlStr];
			
			strContent = [strContent substringFromIndex:range2.location + range2.length];
			range3 = [strContent rangeOfString:@"</a>"];
			if(range3.length <= 0)
				return nil;
			
			NSString *gadgetTabName = [strContent substringToIndex:range3.location]; 
			NSArray* arrTmpGadgetsInItem = [[NSArray alloc] init];

			arrTmpGadgetsInItem = [self listOfGadgetsWithURL:[domain stringByAppendingFormat:@"%@", gadgetTabUrlStr]];
			GateInDbItem* tmpGateInDbItem = [[GateInDbItem alloc] init];
			[tmpGateInDbItem setObjectWithName:gadgetTabName andURL:gadgetTabUrl andGadgets:arrTmpGadgetsInItem];
			[arrTmpGadgets addObject:tmpGateInDbItem];
			
			strContent = [strContent substringFromIndex:range3.location];
			range1 = [strContent rangeOfString:@"ItemIcon DefaultPageIcon\" href=\""];
		}	
	} while (range1.length > 0);
	
	return arrTmpGadgets;
}

- (id)getAppDelegate
{
	UIApplication* app = [UIApplication sharedApplication];
	id appDelegate = [app delegate];
	return appDelegate;
}

- (void)addCloseBtn
{
	if(!_btnClose)
	{	
		_btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(onCloseBtn)];	
	}
	
	[[self navigationItem] setLeftBarButtonItem:_btnClose];		
}

-(void)onCancelCopy
{
	[self._currenteXoFile release];
	self._currenteXoFile = nil;
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
	[_arrDicts removeAllObjects];
	_arrDicts = [self getPersonalDriveContent:self._currenteXoFile];
	
	[_filesView setDriverContent:_arrDicts withDelegate:self];

}

- (IBAction)onNewsBtn
{
	[self addCloseBtn];
	[[self view] addSubview:_newsView];
	_tempView = _newsView;
	
}

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
	[_filesView onFileActionbtn];
}

-(void)fileAction:(NSString *)protocol source:(NSString *)source destination:(NSString *)destination data:(NSData *)data
{
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
		
	}else if([protocol isEqualToString:@"COPY"])
	{
		[request setHTTPMethod:@"PUT"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
		NSData *dataFile = [httpClient sendRequestWithAuthorization:destination];
		[request setHTTPBody:dataFile];

	}else
	{
		[request setHTTPMethod:@"MOVE"];
		[request setValue:destination forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
	}
	
	NSString *s = @"Basic ";
    NSString *author = [s stringByAppendingString: [httpClient stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];
	[request setValue:author forHTTPHeaderField:@"Authorization"];
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSUInteger statusCode = [response statusCode];
	if(!(statusCode >= 200 && statusCode < 300))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %d!", statusCode] message:@"Can not transfer file" delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
	_arrDicts = [self getPersonalDriveContent:_currenteXoFile];
	[_filesView setDriverContent:_arrDicts withDelegate:self];
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
	}
	//_arrChatUsers = arrUsers;
	 
}

- (void)showChatWindowWithXMPPUser:(XMPPUser*)xmppUser listMsg:(NSMutableDictionary *)listMsg
{	
	[[self navigationItem] setTitle:[[xmppUser jid] user]];
	
	for (int i = 0; i < [_arrChatUsers count]; i++)
	{
		if([[_arrChatUsers objectAtIndex:i] getChatUserId] == [[xmppUser jid] user])
		{
			//[_chatWindow initChatWindowWithDelegate:self andXMPPClient:_xmppClient andXMPPUsers:xmppUser];
				
			[ _chatWindow initChatWindowWithDelegate:self andXMPPClient:_xmppClient andExoChatUser:[_arrChatUsers objectAtIndex:i]  listMsg:listMsg];
			_chatWindow._arrChatUsers = self._arrChatUsers;
			
			[[self navigationItem] setLeftBarButtonItem:_btnChatViewBack];
			//self.navigationItem.leftBarButtonItem = _btnClose;
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

- (NSMutableArray*)getPersonalDriveContent:(eXoFile *)file
{
	NSString *urlStr = [file._fatherUrlStr stringByAppendingFormat:@"/%@",
								 [file._fileName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		
	NSData* dataReply = [httpClient sendRequestWithAuthorization:urlStr];
	NSString* strData = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
	
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
			NSString *fileName = [strData substringWithRange:NSMakeRange(range1.length + range1.location, range2.location - range1.location - range1.length)];
			if(![fileName isEqualToString:@".."])
			{
				eXoFile *file = [[eXoFile alloc] initWithUrlStr:[urlStr stringByAppendingFormat:@"/%@", fileName]];
				[arrDicts addObject:file];
			}

		}
		if(range2.length > 0)
			strData = [strData substringFromIndex:range2.location + range2.length];
	} while (range1.length > 0);
	
	return arrDicts;
}

- (IBAction)onBackBtn
{

	startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	[startThread start];
	
	_currenteXoFile._fileName = [_currenteXoFile._fatherUrlStr lastPathComponent];
	_currenteXoFile._fatherUrlStr = [_currenteXoFile._fatherUrlStr stringByDeletingLastPathComponent];
	_currenteXoFile._fatherUrlStr = [_currenteXoFile._fatherUrlStr stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	
	_arrDicts = [self getPersonalDriveContent:self._currenteXoFile];
	
	
	[_filesView setDriverContent:_arrDicts withDelegate:self];
	
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
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *tmpStr = _currenteXoFile._fileName;
	if(_bBackFromGadgets)
		self.navigationItem.leftBarButtonItem = nil;
	else if([tmpStr isEqualToString:@"Private"])
	{
		[self addCloseBtn];
	}
	else
	{
		//[_btnBack setTitle:[_dictLocalize objectForKey:@"BackButton"]];
		[[self navigationItem] setLeftBarButtonItem:_btnBack];
	}
	
	if(_bBackFromGadgets)
		self.navigationItem.rightBarButtonItem = _btnSignOut;

	[pool release];
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
		//tmpStr = @"eXo Native Applications";
		tmpStr = [_dictLocalize objectForKey:@"NativeApplicationsHeader"];
	}
	else if(section == 1)
	{
		//tmpStr = @"List of eXo Gadgets";
		if([_arrGadgets count] > 0)
		{	
		tmpStr = [_dictLocalize objectForKey:@"GadgetsHeader"];
	}	
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
	//if(indexPath.section == 0)
	//	return 60.0;
	return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	switch (indexPath.section)
	{
		case 0:
		{	
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			
			cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier];
			UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 20.0, 210.0, 20.0)];
			titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
			[cell addSubview:titleLabel];
			
			/*
			UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 25.0, 210.0, 33.0)];
			descriptionLabel.numberOfLines = 2;
			descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
			[cell addSubview:descriptionLabel];
			*/
			
			UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
			[cell addSubview:imgV];

			if(indexPath.row == 0)
			{
				titleLabel.text = @"Chat";		
				//descriptionLabel.text = [_dictLocalize objectForKey:@"ChatDescription"];
				if(_xmppClient != nil && [_xmppClient isConnected] && [_xmppClient isAuthenticated])
					imgV.image = [UIImage imageNamed:@"onlineicon.png"];
				else
					imgV.image = [UIImage imageNamed:@"offlineicon.png"];
			}
			else if(indexPath.row == 1)
			{
				
				titleLabel.text = @"Files";
				//descriptionLabel.text = [_dictLocalize objectForKey:@"FileDescription"];
				imgV.image = [UIImage imageNamed:@"filesApp.png"];

			}
			else
			{
				titleLabel.text = @"eXoActivity";					
				//descriptionLabel.text = [_dictLocalize objectForKey:@"ActivityDescription"];
				imgV.image = [UIImage imageNamed:@"ActivityIcon.png"];
				
			}
			
			break;
		}	
			
		case 1:
		{
			GateInDbItem *gadgetTab = [_arrGadgets objectAtIndex:indexPath.row];
			
			cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			
			UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];			
			imgView.image = [UIImage imageNamed:@"Dashboard.png"];			
			[cell addSubview:imgView];
			
			UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 20.0, 210.0, 20.0)];
			titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
			titleLabel.text = gadgetTab._strDbItemName;
			[cell addSubview:titleLabel];
			
			break;
		}
	}
	
	return cell;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	return YES;
}

-(void)createFileView
{
	if(_currenteXoFile == nil)
	{
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
		NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
		NSString* urlStr = [domain stringByAppendingString:@"/rest/private/jcr/repository/collaboration/Users/"];
		
		urlStr = [urlStr stringByAppendingString:username];
		urlStr = [urlStr stringByAppendingString:@"/Private"];
		_currenteXoFile = [[eXoFile alloc] initWithUrlStr:urlStr];
	}
	
	
	if(!_filesView)
	{
		_filesView = [[eXoFilesView alloc] init];
	}
	
	[[self view] addSubview:_filesView];
	_tempView = _filesView;
	
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
				eXoActivityStreamsViewController *eXoActivity = [[eXoActivityStreamsViewController alloc] initWithNibAndUrl:@"eXoActivityStreamsViewController2" bundle:nil url:nil];
				[self.navigationController pushViewController:eXoActivity animated:YES];
				[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
			}
			
			[startThread cancel];
			
			break;
		}
			
		case 1:
		{
			eXoGadgetViewController *gadgetViewController = [[eXoGadgetViewController alloc] initWithStyle:UITableViewStyleGrouped delegate:self gadgetTab:[_arrGadgets objectAtIndex:indexPath.row]];
			[self.navigationController pushViewController:gadgetViewController animated:YES];
			break;
		}
			
		default:
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
