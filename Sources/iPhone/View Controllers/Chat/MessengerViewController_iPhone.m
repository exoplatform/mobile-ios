//
//  eXoFilesView.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "MessengerViewController_iPhone.h"
#import "eXoApplicationsViewController.h"
#import "DataProcess.h"
#import "XMPPClient.h"
#import "XMPPUser.h"
#import "XMPPJID.h"
#import "XMPPElement.h"
#import "defines.h"
#import "ChatWindowViewController_iPhone.h"

static NSString *kCellIdentifier = @"MyIdentifier";
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333

static BOOL didUpdateRosterForTheFirstTime = NO;

@implementation MessengerViewController_iPhone

+(BOOL)isFirstTimeLogIn
{
	return didUpdateRosterForTheFirstTime;
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id)delegate
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
        _arrChatUsers = [[NSMutableArray alloc] init];
        _delegate = delegate;
	}
	return self;
}


/*
- (void)initForChatWithDelegate:(eXoApplicationsViewController *)delegate
{	
	if(!_msgDict)
		_msgDict = [[NSMutableDictionary alloc] init];
	if(_delegate == nil)
	{
		
		_delegate = delegate;
		_xmppClient = [[XMPPClient alloc] init];
		[_xmppClient addDelegate:self];
		[_xmppClient setAutoLogin:NO];
		[_xmppClient setAutoRoster:YES];
		[_xmppClient setAutoPresence:YES];
		[self updateAccountInfo];
		if(![_xmppClient isConnected])
		{
			[_xmppClient connect];
		}
		else
		{
			[_xmppClient authenticateUser];	
		}
		
		while (!didUpdateRosterForTheFirstTime && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
		{
			
		}
	}	
}
 */


- (void)initMessengerParametersWithDelegate:(id)delegate
{	
    
    //Start the request to load file content
    [self performSelectorInBackground:@selector(startRetrieveUserList) withObject:nil];
    
	if(!_msgDict)
    {
		_msgDict = [[NSMutableDictionary alloc] init];
    }
    
//	if(_delegate == nil)
	{
		_delegate = delegate;
		_xmppClient = [[XMPPClient alloc] init];
		[_xmppClient addDelegate:self];
		[_xmppClient setAutoLogin:NO];
		[_xmppClient setAutoRoster:YES];
		[_xmppClient setAutoPresence:YES];
		[self updateAccountInfo];
		if(![_xmppClient isConnected])
		{
			[_xmppClient connect];
		}
		else
		{
			[_xmppClient authenticateUser];	
		}
		
		while (!didUpdateRosterForTheFirstTime && CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.002, YES) != kCFRunLoopRunFinished)
		{
			
		}
        
        //Call in the main thread update method
        [self performSelectorOnMainThread:@selector(userListIsRetrieved) withObject:nil waitUntilDone:NO];
	}	
			
		}

-(void)startRetrieveUserList
{
    self.view.userInteractionEnabled = NO;
    
    [_hudFolder setCaption:[NSString stringWithFormat:@"Loading user list of: %@",self.title]];
    [_hudFolder setActivity:YES];
    [_hudFolder show];
    
}

-(void)userListIsRetrieved
{
    [_hudFolder setCaption:@"User list is updated"];
    [_hudFolder setActivity:NO];
    [_hudFolder setImage:[UIImage imageNamed:@"19-check"]];
    [_hudFolder update];
    [_hudFolder hideAfter:1.0];
    
    self.view.userInteractionEnabled = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hudFolder = [[ATMHud alloc] initWithDelegate:self];
    [_hudFolder setAllowSuperviewInteraction:YES];
	[self.view addSubview:_hudFolder.view];
    
    self.title = @"Chat";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_arrUsers == nil)
        [self initMessengerParametersWithDelegate:_delegate];
   
}

-(void)viewDidDisappear:(BOOL)animated
{
     if (![self.navigationController.viewControllers containsObject:self])
     {
         didUpdateRosterForTheFirstTime = NO;
//         [_xmppClient disconnect];
	}	
}

//Dealloc method.
- (void) dealloc
{
    [_tblvUsersList release];
    _tblvUsersList = nil;
    
	_delegate = nil;
	
    [_xmppClient disconnect];
    [_xmppClient release];
	_xmppClient = nil;
    
	[_arrUsers release];
    _arrUsers = nil;
    
	[_msgCount release];
    _msgCount = nil;
	
    [_msgDict release];
    _msgDict = nil;
    
    //Release the loader
    [_hudFolder release];
    _hudFolder = nil;
    
    [super dealloc];
}


- (void)updateAccountInfo
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	NSString* userName = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString* password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	NSRange tmpRange1 = [domain rangeOfString:@"http://"];
		if(tmpRange1.length > 0)
			domain = [domain substringFromIndex:tmpRange1.location + tmpRange1.length];
		tmpRange1 = [domain rangeOfString:@":"];
		if(tmpRange1.length > 0)
			domain = [domain substringToIndex:tmpRange1.location];
	
	[_xmppClient setDomain:domain];
	
	int port = 5222;
	[_xmppClient setPort:port]; //maybe port number is not neccessary for this App
	
	BOOL usesSSL = NO;
	BOOL allowsSelfSignedCertificates = NO;
	BOOL allowsSSLHostNameMismatch = NO;
	
	[_xmppClient setUsesOldStyleSSL:usesSSL];
	[_xmppClient setAllowsSelfSignedCertificates:allowsSelfSignedCertificates];
	[_xmppClient setAllowsSSLHostNameMismatch:allowsSSLHostNameMismatch];

	NSString* resource = @"";
	NSString* userLocation = @"@";
	userLocation = [userLocation stringByAppendingString:domain];
	
	NSString* jid_name = [userName stringByAppendingString:userLocation];
	XMPPJID* jid = [XMPPJID jidWithString:jid_name resource:resource];
	[_xmppClient setMyJID:jid];
	[_xmppClient setPassword:password];
}

-(void) checkMsg
{
	int count = 0;
	for(int i = 0; i < [_msgCount count]; i++)
	{
		count += [[_msgCount objectAtIndex:i] intValue];
	}
	
	if(count > 0)
	{
		//_delegate._isNewMsg = TRUE;
		//_delegate._btnNotificationRecievedMessage.hidden = NO;
	}
	else
	{
		//_delegate._isNewMsg = FALSE;
		//_delegate._btnNotificationRecievedMessage.hidden = YES;
	}		
}

- (void)setChatClient:(XMPPClient*)xmppClient
{
	_xmppClient = xmppClient;
}

- (void)setChatUsers:(NSArray*)arrUsers
{
    
    [_arrChatUsers removeAllObjects];
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_arrUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 15.0, 260.0, 20.0)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        titleLabel.tag = kTagForCellSubviewTitleLabel;
        [cell addSubview:titleLabel];
        [titleLabel release];

        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 30, 30)];
        imgView.tag = kTagForCellSubviewImageView;
        [cell addSubview:imgView];
        [imgView release];
    }

	eXoChatUser* exochatuser = [_arrChatUsers objectAtIndex:indexPath.row];
    XMPPUser* xmppUser = [exochatuser getXmppUser];
	
	
	UILabel* titleLabel = (UILabel *)[cell viewWithTag:kTagForCellSubviewTitleLabel];
	titleLabel.text = [xmppUser nickname];

    UIImageView* imgView = (UIImageView *)[cell viewWithTag:kTagForCellSubviewImageView];
	if([xmppUser isOnline])
	{	
		titleLabel.textColor = [UIColor blueColor];
		imgView.image = [UIImage imageNamed:@"onlineuser.png"];
	}
	else
	{
		titleLabel.textColor = [UIColor blackColor];
		imgView.image = [UIImage imageNamed:@"offlineuser.png"];
	}
	
	int msgCount = [[_msgCount objectAtIndex:indexPath.row] intValue];
	
	if (msgCount > 0) 
	{
		UIButton* notificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[notificationBtn setFrame:CGRectMake(25.0, 0.0, 19, 19)];
		[notificationBtn setBackgroundImage:[UIImage imageNamed:@"notification.png"] forState:UIControlStateNormal];
		[notificationBtn setTitle:[NSString stringWithFormat:@"%d",msgCount] forState:UIControlStateNormal];
		[notificationBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
		[notificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[notificationBtn setEnabled:NO];
		[cell addSubview:notificationBtn];
        
        //no release of the notificationBtn, because it is created with an autorelease
        
	}
	
	return cell;
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	//if(_delegate && [_delegate respondsToSelector:@selector(showChatWindowWithXMPPUser: listMsg:)])
	{
//		XMPPUser* xmppUser = [_arrUsers objectAtIndex:indexPath.row];
		//_delegate._currentChatUser = [xmppUser address];
		[_msgCount replaceObjectAtIndex:indexPath.row withObject:@"0"];
		[_tblvUsersList reloadData];
		[self checkMsg];
		//[_delegate showChatWindowWithXMPPUser:xmppUser listMsg:_msgDict];
        if (_chatWindowViewController_iPhone == nil) 
        {
            _chatWindowViewController_iPhone = [[ChatWindowViewController_iPhone alloc] initWithNibName:@"ChatWindowViewController_iPhone" bundle:nil];
            
        }
        
        eXoChatUser* exochatuser = [_arrChatUsers objectAtIndex:indexPath.row];
        
        [_chatWindowViewController_iPhone initChatWindowWithDelegate:self andXMPPClient:_xmppClient andExoChatUser:exochatuser listMsg:_msgDict];
        
        if ([self.navigationController.viewControllers containsObject:_chatWindowViewController_iPhone]) 
        {
            [self.navigationController popToViewController:_chatWindowViewController_iPhone animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:_chatWindowViewController_iPhone animated:YES];
            [_chatWindowViewController_iPhone setTitle:[[exochatuser getXmppUser] nickname]];
        }
	}
}

#pragma mark XMPPClient Delegate Methods:

- (void)xmppClientDidConnect:(XMPPClient *)sender
{
	[_xmppClient authenticateUser];
}

- (void)xmppClientDidUpdateRoster:(XMPPClient *)sender
{
	[_arrUsers release];
	_arrUsers = [[_xmppClient sortedUsersByAvailabilityName] retain];	
	
	_msgCount = [[NSMutableArray alloc] initWithCapacity:[_arrUsers count]];

	for(int i = 0; i < [_arrUsers count]; i++)
	{
		[_msgCount addObject:@"0"];
		NSMutableString *chatStr = [[NSMutableString alloc] initWithString:@""];
		[_msgDict setObject:chatStr forKey:[[[_arrUsers objectAtIndex:i] jid] full]];
        [chatStr release];
	}
	
//	if(_delegate && [_delegate respondsToSelector:@selector(setChatClient:)])
//	{
//		[_delegate setChatClient:_xmppClient];
//	}
//	
//	if(_delegate && [_delegate respondsToSelector:@selector(setChatUsers:)])
//	{
//		[_delegate setChatUsers:_arrUsers];
//	}
	
    [self setChatClient:_xmppClient];
    [self setChatUsers:_arrUsers];
    
	[_tblvUsersList reloadData];
	
	didUpdateRosterForTheFirstTime = YES;
}

- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message
{
	
	NSString *strValue = [NSString stringWithString:[message stringValue]];
	if(strValue == nil || [strValue isEqualToString:@""])
	{
		return;
	}
	
	NSString *chatUser = [NSString stringWithString:[message fromStr]];
	NSRange range = [chatUser rangeOfString:@"/"];
	if(range.length > 0)
		chatUser = [chatUser substringToIndex:range.location];
	
	NSMutableString *tmp = [NSMutableString stringWithString:[_msgDict objectForKey:chatUser]];
	
	if(![tmp isEqualToString:@""])
		[tmp appendString:@"<br/>"];
	
	[tmp appendString: strValue];
	[_msgDict setObject:tmp forKey:chatUser];
	
    /*
	if(_delegate && [_delegate respondsToSelector:@selector(receivedChatMsg: listMsg:)])
	{
		if(![chatUser isEqualToString: _delegate._currentChatUser])
		{
			for(int i = 0; i < [_arrUsers count]; i++)
			{
				XMPPUser *xmppUser = [_arrUsers objectAtIndex:i];

				if([chatUser isEqualToString: [xmppUser address]])
				{
					int count = [[_msgCount objectAtIndex:i] intValue];
					count++;
					
					[_msgCount replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", count]];
					[self checkMsg];
					break;
				}
			}
		}
		
		[_tblvUsersList reloadData];
		
		[_delegate receivedChatMsg:message listMsg:_msgDict];
	}
	*/
    
    [_chatWindowViewController_iPhone receivedChatMsg:message listMsg:_msgDict];
}

@end
