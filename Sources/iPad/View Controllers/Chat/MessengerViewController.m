//
//  MessengerViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import "MessengerViewController.h"
#import "MainViewController.h"
#import "XMPPClient.h"
#import "XMPPUser.h"
#import "XMPPJID.h"
#import "XMPPElement.h"
#import "defines.h"
#import "AppContainerViewController.h"
#import "XMPPResource.h"
#import "XMPPPresence.h"

static NSString* kCellIdentifier = @"MyIdentifier";
static XMPPClient*	_xmppClient;
static BOOL didUpdateRoster = NO;

NSString* processMsg(NSString* message, int maxLength)
{
	NSLog(@"%d", [message length]);
	
	NSMutableString* returnStr = [[NSMutableString alloc] initWithString:@""];
	NSArray* brArr = [message componentsSeparatedByString:@" "];
	
	for(int i = 0; i < [brArr count]; i++)
	{
		NSMutableString* tmp = [[NSMutableString alloc] initWithString:[brArr objectAtIndex:i]];
		int wordLength = [tmp length];
		if(wordLength > maxLength)
		{
			if(i > 0)
			[returnStr appendString:@"<br/>"];
			int count = 1, maxLenghtTmp = maxLength;
			while(wordLength > maxLenghtTmp)
			{
				count++;
				[tmp insertString:@"<br/>" atIndex:maxLength];
				maxLenghtTmp = (maxLength + 5) * count;
				wordLength += 5;
			}
		}
		[returnStr appendFormat:@"%@ ", tmp];
	}
	
	return returnStr;
}

NSString* base64Encoding(NSData* data)
{
	if ([data length] == 0)
	{
		return @"";
	}
	const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
    char* characters = malloc((([data length] + 2) / 3) * 4);
	if (characters == NULL)
	{	
		return nil;
	}
	
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	
	while (i < [data length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [data length])
		{
			buffer[bufferLength++] = ((char *)[data bytes])[i++];
		}
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		
		if (bufferLength > 1)
		{	
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		}	
		else 
		{
			characters[length++] = '=';
		}	
		if (bufferLength > 2)
		{	
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		}	
		else 
		{
			characters[length++] = '=';	
		}	
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

NSString* imageStr(NSString* fileName, NSString* type)
{
	NSString* iconChat = [[NSString alloc] init];
	NSData* iconChatData = [[NSData alloc] init];
	iconChat = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
	iconChatData = [NSData dataWithContentsOfFile:iconChat];
	return [base64Encoding(iconChatData) retain];
}



//========================================================================================
#pragma mark MessengerUser

@implementation MessengerUser

@synthesize _intMessageCount, _xmppUser, _mstrHtmlPortrait, _mstrHtmlLanscape;

-(id)init
{
	if(self = [super init])
	{
		
		[self creatHTMLstring];		
		_intMessageCount = 0;
	}
	
	return self;
}

-(void)creatHTMLstring
{
	[_mstrHtmlPortrait release];
	_mstrHtmlPortrait = nil;
	_mstrHtmlPortrait = [[NSMutableString alloc] initWithString:@""];
	[_mstrHtmlPortrait appendString:@"<html><head><script type=\"text/javascript\">"
	 "function pageScroll() {"
	 "dh=document.body.scrollHeight;"
	 "ch=document.body.clientHeight;"
	 "moveme=dh-ch;"
	 "window.scrollTo(0,moveme);"
	 "};"
	 "</script></head>"
	 "<body BGCOLOR=\"#DADADA\" onLoad=\"pageScroll()\">"
	 "<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><table boder=\"0\" width=\"752\"></table>"
	 "</body></html>"];
	
	[_mstrHtmlLanscape release];
	_mstrHtmlLanscape = nil;
	_mstrHtmlLanscape = [[NSMutableString alloc] initWithString:@""];
	[_mstrHtmlLanscape appendString:@"<html><head><script type=\"text/javascript\">"
	 "function pageScroll() {"
	 "dh=document.body.scrollHeight;"
	 "ch=document.body.clientHeight;"
	 "moveme=dh-ch;"
	 "window.scrollTo(0,moveme);"
	 "};"
	 "</script></head>"
	 "<body BGCOLOR=\"#DADADA\" onLoad=\"pageScroll()\">"
	 "<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><table boder=\"0\" width=\"687\"></table>"
	 "</body></html>"];	
}

@end


@implementation MessengerViewController

@synthesize _tblvUsers;
@synthesize currentChatUserIndex;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		currentChatUserIndex = -1;
		// Custom initialization
		_tblvUsers = [[UITableView alloc] init];
		[_tblvUsers setDelegate:self];
		[_tblvUsers setDataSource:self];
		[[self view] addSubview:_tblvUsers];	
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
	[self setTitle:@"Chat Application"];
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

+ (XMPPClient *)getXmppClient
{
	return _xmppClient;
}

- (int)getCurrentChatUserIndex
{
	return currentChatUserIndex;
}

- (void)setCurrentChatUserIndex:(int)index
{
	currentChatUserIndex = index;
}

- (NSArray *)getArrChatUsers
{
	return arrChatUsers;
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

- (void)initMessengerParameters
{
	if(_xmppClient == nil)
	{	
		_xmppClient = [[XMPPClient alloc] init];
		[_xmppClient addDelegate:self];
		[_xmppClient setAutoLogin:NO];
		[_xmppClient setAutoRoster:YES];
		[_xmppClient setAutoPresence:YES];
	}	

	[self updateAccountInfo];
	
	if(![_xmppClient isConnected])
	{
		[_xmppClient connect];
	}
	else
	{
		[_xmppClient authenticateUser];
	}	
	
	
	iconChatMe = imageStr(@"me", @"png");
	iconChatFriend = imageStr(@"you", @"png");
	topLeftStr = imageStr(@"tl", @"png");
	topRightStr = imageStr(@"tr", @"png");
	bottomLeftStr = imageStr(@"bl", @"png");
	bottomRightStr = imageStr(@"br", @"png");
	topHorizontalStr = imageStr(@"TopHorizontal", @"png");
	bottomHorizontalStr = imageStr(@"BottomHorizontal", @"png");
	
	while (!didUpdateRoster && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:20]])
	{
		
	}
	
}

-(NSString *)createChatContentFor:(NSString *)chatName content:(NSString *)content isMe:(BOOL)isMe portrait:(BOOL)portrait
{
	NSRange range = [chatName rangeOfString:@"@"];
	if(range.length > 0)
	{
		chatName = [chatName substringToIndex:range.location];
	}
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *msgTime = [dateFormatter stringFromDate:[NSDate date]];
	
	NSString *chatIcon;
	NSString *tl, *tr, *bl, *br, *th, *bh, *color;
	if(isMe)
	{
		chatIcon = iconChatMe;
	}
	else
	{
		chatIcon = iconChatFriend;
	}
	
	tl = topLeftStr;
	tr =topRightStr;
	bl = bottomLeftStr;
	br = bottomRightStr;
	th = topHorizontalStr;
	bh = bottomHorizontalStr;
	color = @"#F7F7F7";
	
	int width = 752, horizontalWidth = 732, wordMaxLength = 100;
	if(!portrait)
	{
		width = 690;
		horizontalWidth = 670;
		wordMaxLength = 90;
	}
	
	NSString *tempStr = [NSString stringWithFormat:@"<table boder=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=%d>"
						 "<tr>"
						 "<td width=\"20\"><img src=\"data:image/png;base64,%@\" width=\"20\" height=\"20\"></td>"
						 "<td width=\"%d\"><font size=4.5>%@</font></td>"
						 "<td align=\"center\" valign=\"bottom\">%@</td></tr>"
						 "</table>"
						 "<table boder=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=%d>"
						 "<tr>"
						 "<td width=\"10\"><img src=\"data:image/png;base64,%@\" width=\"10\" height=\"10\"></td>"
						 "<td><img src=\"data:image/png;base64,%@\" width=\"%d\" height=\"10\"></td>"
						 "<td align=\"right\"><img src=\"data:image/png;base64,%@\" width=\"10\" height=\"10\"></td>"
						 "</tr>"
						 "</table>"
						 "<table boder=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=%d>"
						 "<tr bgcolor=\"%@\">"
						 "<td width=\"3\" background=\"http://platform.demo.exoplatform.org/chatbar/skin/DefaultSkin/background/LeftMiddleGuestChat3x1.gif\"></td>"
						 "<td width=\"10\"></td>"
						 "<td><div><span>%@</span></div></td>"
						 "<td align=\"right\" width=\"3\" background=\"http://platform.demo.exoplatform.org/chatbar/skin/DefaultSkin/background/RightMiddleGuestChat4x1.gif\"></td>"
						 "</tr>"
						 "</table>"
						 "<table boder=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=%d>"
						 "<tr>"
						 "<td width=\"10\"><img src=\"data:image/png;base64,%@\" width=\"10\" height=\"10\"></td>"
						 "<td><img src=\"data:image/png;base64,%@\" width=\"%d\" height=\"10\"></td>"
						 "<td align=\"right\"><img src=\"data:image/png;base64,%@\" width=\"10\" height=\"10\"></td>"
						 "</tr>",
						 width, chatIcon, width, chatName, msgTime, width,  
						 tl, th, horizontalWidth, tr, width, color, processMsg(content, wordMaxLength), width, bl, bh, horizontalWidth, br];
	
	return tempStr;
}

- (void)updateAccountInfo
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	NSString* userName = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString* password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	for (int i = 0; i < [domain length]; i++)
	{
		NSRange range1 = [domain rangeOfString:@"//"];
		if(range1.length > 0)
		{
			for (int j = range1.location + range1.length + 1; j < [domain length]; j++)
			{
				if([domain characterAtIndex:j] == ':')
				{
					NSRange range2 = NSMakeRange(range1.location + range1.length, j - range1.location - range1.length);
					domain = [domain substringWithRange:range2];
					break;
				}
			}
			break;
		}
		
	}
	
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	return tmpStr;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [arrChatUsers count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
	
	MessengerUser* messengerUser = [arrChatUsers objectAtIndex:indexPath.row];
	XMPPUser* user = messengerUser._xmppUser;
	
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 5.0, 400.0, 30.0)];
	titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
	titleLabel.text = [user nickname];
	[cell addSubview:titleLabel];
	
	UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 24, 24)];

	if([user isOnline])
	{
		titleLabel.textColor = [UIColor blueColor];
		imgV.image = [UIImage imageNamed:@"onlineuser.png"];
	}
	else 
	{
		titleLabel.textColor = [UIColor blackColor];
		imgV.image = [UIImage imageNamed:@"offlineuser.png"];
	}	
	
	[cell addSubview:imgV];
	
	int messageCount = messengerUser._intMessageCount;

	if (messageCount > 0) 
	{
		UIButton* notificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[notificationBtn setFrame:CGRectMake(25.0, 0.0, 19, 19)];
		[notificationBtn setBackgroundImage:[UIImage imageNamed:@"notification.png"] forState:UIControlStateNormal];
		[notificationBtn setTitle:[NSString stringWithFormat:@"%d",messageCount] forState:UIControlStateNormal];
		[notificationBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
		[notificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[notificationBtn setEnabled:NO];
		[cell addSubview:notificationBtn];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[_delegate setCurrentViewIndex:3];
	MessengerUser* messengerUser = [arrChatUsers objectAtIndex:indexPath.row]; 
	messengerUser._intMessageCount = 0;
	[_delegate setLeftBarButtonForNavigationBar];
	currentChatUserIndex = indexPath.row;	
	[_delegate showChatWindowWithUser:messengerUser andXMPPClient:_xmppClient];
	[_tblvUsers reloadData];
}


#pragma mark XMPPClient Delegate Methods:

- (void)xmppClientDidConnect:(XMPPClient *)sender
{
	[_xmppClient authenticateUser];
}

- (void)xmppClientDidUpdateRoster:(XMPPClient *)sender
{
	if(arrChatUsers == nil)
	{
		arrChatUsers = [[NSMutableArray alloc] init];
	}	
	[arrChatUsers removeAllObjects];
	
	if([_xmppClient isAuthenticated])
	{
		AppContainerViewController *appVcl = [_delegate getAppContainerViewController];
		[[appVcl getTableViewAppList] reloadData];
	}
	
	NSArray *arrTmp = [_xmppClient sortedUsersByAvailabilityName];
	
	for(int i = 0; i < [arrTmp count]; i++)
	{
		MessengerUser* messengerUser = [[MessengerUser alloc] init];
		messengerUser._xmppUser = [arrTmp objectAtIndex:i];
		messengerUser._intMessageCount = 0;
		
		[arrChatUsers addObject:messengerUser]; 
	}
	
	[_tblvUsers reloadData];
	
	didUpdateRoster = YES;
}

- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message
{
	NSString *strValue = [NSString stringWithString:[message stringValue]];
	if(strValue == nil || [strValue isEqualToString:@""])
	{
		return;
	}
	
	NSString *fromStr = [NSString stringWithString:[message fromStr]];
	NSRange range = [fromStr rangeOfString:@"/"];
	if(range.length > 0)
	{
		fromStr = [fromStr substringToIndex:range.location];
	}
	NSString *tempStr;
	
	MessengerUser* messengerUser;
	
	for(int i = 0; i < [arrChatUsers count]; i++)
	{
		messengerUser = [arrChatUsers objectAtIndex:i];
		if([fromStr isEqualToString:[messengerUser._xmppUser address]])
		{
			NSRange insertIndex = [messengerUser._mstrHtmlPortrait rangeOfString:@"</table></body>"];
			tempStr =  [self createChatContentFor:fromStr content:strValue isMe:NO portrait:YES];
			[messengerUser._mstrHtmlPortrait insertString:tempStr atIndex:insertIndex.location];
			
			insertIndex = [messengerUser._mstrHtmlLanscape rangeOfString:@"</table></body>"];
			tempStr =  [self createChatContentFor:fromStr content:strValue isMe:NO portrait:NO];
			[messengerUser._mstrHtmlLanscape insertString:tempStr atIndex:insertIndex.location];
			
			if(currentChatUserIndex == i)
			{
				messengerUser._intMessageCount = 0;
				[_delegate setCurrentViewIndex:3];
			}	
			else
			{
				messengerUser._intMessageCount ++;
				[_delegate setHiddenForNewMessageImage:NO];
				[_delegate setCurrentViewIndex:4];
				[_delegate addChatButton:messengerUser._xmppUser userIndex:i];
			}
			
			[_delegate receivedChatMsg];
			
			break;
		}
		
	}
	
	[_tblvUsers reloadData];
	
	[_delegate setLeftBarButtonForNavigationBar];
	
}

@end
