//
//  MainViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import "MainViewController.h"
#import "eXoMobileViewController.h"
#import "defines.h"
#import "Connection.h"
#import "AppContainerViewController.h"
#import "GadgetDisplayController.h"
#import "FilesViewController.h"
#import "FileContentDisplayController.h"
#import "MessengerViewController.h"
#import "ChatWindowViewController.h"
#import "XMPPClient.h"
#import "XMPPUser.h"
#import "MoreLiveChatViewController.h"
#import "Gadget_iPad.h"

@implementation MainViewController


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
		_appContainerViewController = [[AppContainerViewController alloc] initWithNibName:@"AppContainerViewController" bundle:nil];		
		[_appContainerViewController setDelegate:self];
		
		_gadgetDisplayController = [[GadgetDisplayController alloc] initWithNibName:@"GadgetDisplayController" bundle:nil];
		[_gadgetDisplayController setDelegate:self];
		
		_filesViewController = [[FilesViewController alloc] initWithNibName:@"FilesViewController" bundle:nil];
		[_filesViewController setDelegate:self];
		
//		_messengerViewController = [[MessengerViewController alloc] initWithNibName:@"MessengerViewController" bundle:nil];
//		[_messengerViewController setDelegate:self];
//		
//		_nvMessengerViewController = [[UINavigationController alloc] initWithRootViewController:_messengerViewController];
        
		_btnLeftEdgeNavigation = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8, 9)];
		[_btnLeftEdgeNavigation setUserInteractionEnabled:NO];
		[_btnLeftEdgeNavigation setBackgroundImage:[UIImage imageNamed:@"LeftEdgeNavigation.png"] forState:UIControlStateNormal];
		[[_nvMessengerViewController view] addSubview:_btnLeftEdgeNavigation];
		_btnRightEdgeNavigation = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8, 9)];
		[_btnRightEdgeNavigation setUserInteractionEnabled:NO];
		[_btnRightEdgeNavigation setBackgroundImage:[UIImage imageNamed:@"RightEdgeNavigation.png"] forState:UIControlStateNormal];
		[[_nvMessengerViewController view] addSubview:_btnRightEdgeNavigation];
		
		_chatWindowViewController = [[ChatWindowViewController alloc] initWithNibName:@"ChatWindowViewController" bundle:nil];
		[_chatWindowViewController setDelegate:self];
		
		_vPrevious = [[UIView alloc] init];
		_imgvBackground = [[UIImageView alloc] init];
		
		_imgViewNewMessage = [[UIImageView alloc] init];
		_imgViewNewMessage.image = [UIImage imageNamed:@"newmessage.png"];
		
		_currentViewIndex = 0;
		_liveChatArr = [[NSMutableArray alloc] init];
		
	}
	return self;
}


- (void)setCurrentViewIndex:(short)index
{
	_currentViewIndex = index;
}

- (short)getCurrentViewIndex
{
	return _currentViewIndex;
}

//- (int)getCurrentChatUserIndex
//{
//	return [_messengerViewController getCurrentChatUserIndex];
//}
//
//- (void)setCurrentChatUserIndex:(int)index
//{
//	[_messengerViewController setCurrentChatUserIndex:index];
//}
//
//- (void)setLeftBarButtonForNavigationBar;
//{
//	if(_currentViewIndex != 3)
//	{
//		[self.view addSubview:_imgViewNewMessage];
//		return;
//	}
//		
//	NSArray *arrChatUsers = [_messengerViewController getArrChatUsers];
//	MessengerUser* messengerUser;
//	
//	for(int i = 0; i < [arrChatUsers count]; i++)
//	{
//		messengerUser = [arrChatUsers objectAtIndex:i];
//		if(messengerUser._intMessageCount > 0)
//		{
//			[self.view addSubview:_imgViewNewMessage];
//			return;
//		}
//	}
//		
//	[_imgViewNewMessage removeFromSuperview];
//	
//}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[self localize];
	
	_currentViewIndex = 0;
	[_btnHome setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
	[super viewDidLoad];
	
	_btnMoreChat = [[UIButton alloc] init];
	[_btnMoreChat addTarget:self action:@selector(showLiveChat:) forControlEvents:UIControlEventTouchUpInside];
	[_btnMoreChat setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
}

- (void)addChatButton:(XMPPUser *)user userIndex:(int)index
{
	BOOL add = YES;
	for(int i = 1; i < [_liveChatArr count]; i++)
	{
		UIBarButtonItem *tmp = [_liveChatArr objectAtIndex:i];
		if(tmp.tag == index)
		{
			add = NO;
			break;
		}

	}
	if(add)
	{
		UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(2, 5, 120, 35)];
		[btn addTarget:self action:@selector(chatWindows:) forControlEvents:UIControlEventTouchUpInside];
		NSString* tmpStr = [user address];
		NSRange r = [tmpStr rangeOfString:@"@"];
		if (r.length > 0) 
		{
			tmpStr = [tmpStr substringToIndex:r.location];
		}
		[btn setTitle:tmpStr forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageNamed:@"ChatMinimize.png"] forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btn setTag:index];
		
		UIBarButtonItem *infoButton2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
		infoButton2.tag = index;
		btn.tag = index;
		
		BOOL bExist = NO;
		for (int i = 0; i < [_liveChatArr count]; i++) 
		{
			UIBarButtonItem* tmp  = [_liveChatArr objectAtIndex:i];
			if (tmp.tag == index) 
			{
				bExist = YES;
				break;
			}
		}
		if (!bExist) 
		{
			[_liveChatArr addObject:infoButton2];
		}

		if([_liveChatArr count] < 6)
		{
			[_toolBarChatsLive setItems:(NSArray *)_liveChatArr];
		}
		else
		{
			UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:_btnMoreChat];
			[_liveChatArr insertObject:barBtn atIndex:0];
			//[_liveChatArr addObject:barBtn];
			[_toolBarChatsLive setItems:_liveChatArr];
		}
	}	
}

- (void)removeChatButton:(int)index
{
	for(int i = 0; i < [_liveChatArr count]; i++)
	{
		UIBarButtonItem *tmp = [_liveChatArr objectAtIndex:i];
		if(tmp.tag == index)
		{
			[_liveChatArr removeObjectAtIndex:i];
			break;
		}
	}
	[_toolBarChatsLive setItems:(NSArray *)_liveChatArr];
}

-(void)showLiveChat:(UIButton *)sender
{
	NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
	int count = [_liveChatArr count];
	if(count >= 3)
	{

		for(int i = 2; i < count; i++)
		{
			UIBarButtonItem *barButtonUser = [_liveChatArr objectAtIndex:i];
			[tmpArr addObject:[NSString stringWithFormat:@"%d", barButtonUser.tag]];
		}
			
	}
	MoreLiveChatViewController *moreLiveChat = [[MoreLiveChatViewController alloc] initWithNibName:@"MoreLiveChatViewController" bundle:nil liveChat: tmpArr delegate:self];
	UIPopoverController *popoverCtr = [[UIPopoverController alloc] initWithContentViewController:moreLiveChat];
	[popoverCtr setPopoverContentSize:CGSizeMake(260, 300) animated:YES];
	moreLiveChat._popViewController = popoverCtr;
	[popoverCtr presentPopoverFromRect:sender.frame inView:_toolBarChatsLive permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];	
}

//- (void)openChatWindows:(int)index
//{
//	[self setCurrentViewIndex:3];
//	MessengerUser* messengerUser = [[_messengerViewController getArrChatUsers] objectAtIndex:index]; 
//	messengerUser._intMessageCount = 0;
//	[self setLeftBarButtonForNavigationBar];
//	_messengerViewController.currentChatUserIndex = index;	
//	[self showChatWindowWithUser:messengerUser andXMPPClient:[MessengerViewController getXmppClient]];
//	[_messengerViewController._tblvUsers reloadData];
//}

-(void)chatWindows:(UIButton *)sender
{
	//[_liveChatArr removeObjectAtIndex:[sender tag]];
	[self openChatWindows:sender.tag];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverCtr
{
	[popoverCtr release];
	popoverCtr = nil;
}

- (void)showChatToolBar:(BOOL)show
{
	[_toolBarChatsLive setHidden:!show];
	if(show)
	{
		[[self view] bringSubviewToFront:_toolBarChatsLive];
	}
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

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];
	[_btnSignOut setTitle:[_dictLocalize objectForKey:@"SignOutButton"] forState:UIControlStateNormal];
	[_appContainerViewController localize];
	[_filesViewController localize];
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

- (int)getSelectedLanguage
{
	_intSelectedLanguage = [_delegate getSelectedLanguage];
	return _intSelectedLanguage;
}

- (Connection*)getConnection
{
	return [_delegate getConnection];
}

- (void)loadGadgets
{
	[_appContainerViewController loadGadgets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
		[[_appContainerViewController view] removeFromSuperview];
		[_btnPanel setFrame:CGRectMake(10, 6, 100, 31)];
		[_btnHome setFrame:CGRectMake(120, 6, 30, 30)];
		[_btnSignOut setFrame:CGRectMake(640, 6, 120, 31)];
		
		[[self view] addSubview:_btnPanel];
		
		[_imgvBackground setFrame:CGRectMake(0, 43, 768, 976)];
		[_imgvBackground setImage:[UIImage imageNamed:@"PortraitBkg.png"]];
		
		[[_gadgetDisplayController view] setFrame:CGRectMake(0, 43, 768, 961)];	
		[_gadgetDisplayController._wvGadgetDisplay setFrame:CGRectMake(0, 44, 768, 917)];
		[_gadgetDisplayController._actiLoading setFrame:CGRectMake(334, 475, 30, 30)];		
		[_gadgetDisplayController._lbStatus setFrame:CGRectMake(374, 475, 100, 30)];		
		[_gadgetDisplayController._btnLeftEdgeNavigation setFrame:CGRectMake(0, 0, 8, 9)];
		[_gadgetDisplayController._btnRightEdgeNavigation setFrame:CGRectMake(761, 0, 8, 9)];
		
		[[_filesViewController view] setFrame:CGRectMake(0, 43, 768, 961)];
		[_filesViewController._fileContentDisplayController._actiLoading setFrame:CGRectMake(334, 453, 30, 30)];
		[_filesViewController._fileContentDisplayController._lbStatus setFrame:CGRectMake(374, 453, 100, 30)];		
		[_filesViewController._btnLeftEdgeNavigation setFrame:CGRectMake(0, 0, 8, 9)];
		[_filesViewController._btnRightEdgeNavigation setFrame:CGRectMake(761, 0, 8, 9)];
		
//		[[_nvMessengerViewController view] setFrame:CGRectMake(0, 43, 768, 961)];
//		[_messengerViewController._tblvUsers setFrame:CGRectMake(0, 0, 768, 873)];
//		[_btnRightEdgeNavigation setFrame:CGRectMake(761, 0, 8, 9)];
//		[[_chatWindowViewController view] setFrame:CGRectMake(0, 44, 768, 939)];

		[_chatWindowViewController._wvChatContentDisplay setFrame:CGRectMake(0, 0, 768, 827)];
		[_chatWindowViewController._vTextInputArea setFrame:CGRectMake(0, 827, 768, 90)];
		[_chatWindowViewController._tvTextInput setFrame:CGRectMake(8, 8, 645, 73)];
		[_chatWindowViewController._imgvNewMsgArea setFrame:CGRectMake(696, 4, 31, 31)];
		[_chatWindowViewController._btnSend setFrame:CGRectMake(661, 40, 100, 41)];	
		
		[_toolBarChatsLive setFrame:CGRectMake(0, 960, 768, 44)];
		[_btnMoreChat setFrame:CGRectMake(728, 5, 35, 35)];
		_imgViewNewMessage.frame = CGRectMake(160, 6, 31, 31);
	}
	
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
		[_btnPanel removeFromSuperview];
		[_btnHome setFrame:CGRectMake(10, 6, 30, 30)];
		[_btnSignOut setFrame:CGRectMake(896, 6, 120, 31)];
		
		[popoverController dismissPopoverAnimated:YES];
		
		[_imgvBackground setFrame:CGRectMake(321, 43, 703, 707)];
		[_imgvBackground setImage:[UIImage imageNamed:@"LandscapeBkg.png"]];
		
		[[_appContainerViewController view] setFrame:CGRectMake(0, 43, 320, 705)];
		[[self view] addSubview:[_appContainerViewController view]];

		[[_gadgetDisplayController view] setFrame:CGRectMake(321, 43, 703, 705)];
		[_gadgetDisplayController._wvGadgetDisplay setFrame:CGRectMake(0, 44, 703, 660)];
		[_gadgetDisplayController._actiLoading setFrame:CGRectMake(300, 335, 30, 30)];
		[_gadgetDisplayController._lbStatus setFrame:CGRectMake(340, 335, 100, 30)];	
		[_gadgetDisplayController._btnLeftEdgeNavigation setFrame:CGRectMake(0, 0, 8, 9)];
		[_gadgetDisplayController._btnRightEdgeNavigation setFrame:CGRectMake(696, 0, 8, 9)];
		
		[[_filesViewController view] setFrame:CGRectMake(321, 43, 703, 705)];
		[_filesViewController._fileContentDisplayController._actiLoading setFrame:CGRectMake(300, 313, 30, 30)];
		[_filesViewController._fileContentDisplayController._lbStatus setFrame:CGRectMake(340, 313, 100, 30)];				
		[_filesViewController._btnLeftEdgeNavigation setFrame:CGRectMake(0, 0, 8, 9)];
		[_filesViewController._btnRightEdgeNavigation setFrame:CGRectMake(696, 0, 8, 9)];

		
//		[[_nvMessengerViewController view] setFrame:CGRectMake(321, 43, 703, 705)];
//		[_messengerViewController._tblvUsers setFrame:CGRectMake(0, 0, 703, 600)];
//		[_btnRightEdgeNavigation setFrame:CGRectMake(696, 0, 8, 9)];
//		[[_chatWindowViewController view] setFrame:CGRectMake(321, 44, 703, 661)];
//		[_chatWindowViewController._wvChatContentDisplay setFrame:CGRectMake(0, 0, 703, 560)];
//		[_chatWindowViewController._vTextInputArea setFrame:CGRectMake(0, 570, 703, 90)];
//		[_chatWindowViewController._tvTextInput setFrame:CGRectMake(8, 8, 580, 73)];
//		[_chatWindowViewController._imgvNewMsgArea setFrame:CGRectMake(631, 4, 31, 31)];
//		[_chatWindowViewController._btnSend setFrame:CGRectMake(596, 40, 100, 40)];
		
		[_toolBarChatsLive setFrame:CGRectMake(321, 704, 703, 44)];
		[_btnMoreChat setFrame:CGRectMake(665, 5, 35, 35)];
		_imgViewNewMessage.frame = CGRectMake(50, 6, 31, 31);
	}
	
	[[_filesViewController._fileContentDisplayController view] setFrame:[_filesViewController._tbvFiles frame]];
	[_filesViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
//	[_messengerViewController._tblvUsers reloadData];
//	[_chatWindowViewController changeOrientation:interfaceOrientation];
	[[self view] addSubview:_btnSignOut];			
	
//	if ([_nvMessengerViewController topViewController] != _messengerViewController) 
//	{
//		[self showChatToolBar:NO];
//	}
	_interfaceOrientation = interfaceOrientation;
}

- (IBAction)onPanelBtn:(id)sender
{
	popoverController = [[UIPopoverController alloc] initWithContentViewController:_appContainerViewController];
	[popoverController setPopoverContentSize:CGSizeMake(320, 707) animated:YES];
	[popoverController presentPopoverFromRect:[_btnPanel frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];	
}

- (void)startFilesApplication
{
	if(_currentViewIndex == 2)
		_currentViewIndex = 4;
	else if(_currentViewIndex == 3)
		_currentViewIndex = 5;
	else
		_currentViewIndex = 1;
	
	[_vPrevious removeFromSuperview];
	[[self view] addSubview:[_filesViewController view]];
	[_filesViewController initWithRootDirectory];
	[_filesViewController getPersonalDriveContent:_filesViewController._currenteXoFile];
	_vPrevious = [_filesViewController view];
	
	[_filesViewController._tbvFiles reloadData];
	
	[popoverController dismissPopoverAnimated:YES];
}

- (void)startMessengerApplication
{
//	if(_currentViewIndex == 3)
//		[self setLeftBarButtonForNavigationBar];
//	else
//		_currentViewIndex = 2;
//	
//	[_messengerViewController initMessengerParameters];
//	[_vPrevious removeFromSuperview];
//	[[self view] addSubview:[_nvMessengerViewController view]];
//	_vPrevious = [_nvMessengerViewController view];
//	[_messengerViewController._tblvUsers reloadData];
//
//	if ([_nvMessengerViewController topViewController] == _chatWindowViewController) 
//	{
//		[self showChatToolBar:NO];
//	}
//	else 
//	{
//		if ([_nvMessengerViewController topViewController] == _messengerViewController) 
//		{
//			[self showChatToolBar:YES];
//		}
//	}
//
//	[popoverController dismissPopoverAnimated:YES];
}

//- (MessengerViewController*)getMessengerViewController
//{
//	return _messengerViewController;
//}
//
//- (AppContainerViewController*)getAppContainerViewController
//{
//	return _appContainerViewController;
//}

- (void)showChatWindowWithUser:(MessengerUser*)messengerUser andXMPPClient:(XMPPClient*)xmppClient
{
	[_chatWindowViewController initChatWindowWithUser:messengerUser andXMPPClient:xmppClient];
	
	if([_nvMessengerViewController.viewControllers containsObject:_chatWindowViewController])
	{
		[_nvMessengerViewController popToViewController:_chatWindowViewController animated:YES];
	}
	else 
	{
		[_nvMessengerViewController pushViewController:_chatWindowViewController animated:YES];
		[self showChatToolBar:NO];
	}
}

- (void)setHiddenForNewMessageImage:(BOOL)bHidden
{
	[_chatWindowViewController setHiddenForNewMessageImage:bHidden];
}

- (void)receivedChatMsg
{
	[_chatWindowViewController receivedChatMsg];
}

- (void)startGadget:(Gadget_iPad*)gadget
{
	[_vPrevious removeFromSuperview];
	[[self view] addSubview:[_gadgetDisplayController view]];
	[_gadgetDisplayController startGadget:gadget];
	_vPrevious = [_gadgetDisplayController view];
	[popoverController dismissPopoverAnimated:YES];
}

- (IBAction)onHomeBtn:(id)sender
{
	[_vPrevious removeFromSuperview];
	[[self view] addSubview:_imgvBackground];
	_vPrevious = _imgvBackground;
}

- (IBAction)onSignOutBtn:(id)sender
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:@"NO" forKey:EXO_AUTO_LOGIN];
	
	_currentViewIndex = 0;
	
	NSHTTPCookieStorage* store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* cookies = [store cookies];
	for(int i = 0; i < [cookies count]; i++)
	{
		[store deleteCookie:[cookies objectAtIndex:i]];
	}
	[_vPrevious removeFromSuperview];
	[_delegate showLoginViewController];
	if([MessengerViewController getXmppClient] != nil && [[MessengerViewController getXmppClient] isAuthenticated])
	{
		[[MessengerViewController getXmppClient] disconnect];
		[[_appContainerViewController getTableViewAppList] reloadData];
	}
		
	[_imgViewNewMessage removeFromSuperview];
	
	//file app
	_filesViewController._strRootDirectory = @"";
	[_filesViewController._navigationBar setTitle:@"Files Application"];
	[_filesViewController._navigationBar setLeftBarButtonItem:nil];
	
	//messenger app
}


- (void)moveChatWindow:(BOOL)bUp
{
	
	CGRect rect = [[_chatWindowViewController._wvChatContentDisplay superview] frame];
	if (bUp) 
	{
		rect.origin.y -= 270;
		[_chatWindowViewController._wvChatContentDisplay removeFromSuperview];
		UIWebView* tmp = [[UIWebView alloc] initWithFrame:rect];
		[[_chatWindowViewController view] addSubview:tmp];
	}
	else 
	{
		rect.origin.y += 270;
		[_chatWindowViewController._wvChatContentDisplay removeFromSuperview];
		[_chatWindowViewController._wvChatContentDisplay setFrame:rect];
		[[_chatWindowViewController view] addSubview:_chatWindowViewController._wvChatContentDisplay];
	}

}

- (NSString*)getUsername
{
	return _strUsername;
}

- (NSString*)getPassword
{
	return _strPassword;
}
@end
