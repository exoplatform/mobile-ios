//
//  HomeViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "HomeViewController_iPad.h"

#import "Three20UI/UINSStringAdditions.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"

// UI
#import "Three20UI/TTNavigator.h"

// UINavigator
#import "Three20UINavigator/TTURLAction.h"
#import "Three20UINavigator/TTURLMap.h"
#import "Three20UINavigator/TTURLObject.h"

#import "FilesViewController_iPhone.h"
#import "ActivityStreamsViewController_iPad.h"
#import "ChatViewController_iPad.h"
#import "DashboardViewController_iPad.h"
#import "eXoSettingViewController.h"

#import "eXoMobileViewController.h"
#import "FilesViewController.h"
#import "XMPPUser.h"

@implementation HomeViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"Home";
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)loadView 
{
    [super loadView];
    
    _launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
    _launcherView.backgroundColor = [UIColor blackColor];
    _launcherView.delegate = self;
    _launcherView.columnCount = 4;
    
    _launcherView.pages = [NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Activity Streams"
                                                                                     image:@"bundle://onlineicon.png"
                                                                                       URL:@"tt://activityStream" canDelete:YES] autorelease],
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Chat"
                                                                                     image:@"bundle://offlineicon.png"
                                                                                       URL:@"tt://chat" canDelete:YES] autorelease],
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Documents"
                                                                                     image:@"bundle://filesApp.png"
                                                                                       URL:@"tt://documents" canDelete:YES] autorelease],
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Dashboard"
                                                                                     image:@"bundle://Dashboard.png"
                                                                                       URL:@"tt://dashboard" canDelete:YES] autorelease],
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Settings"
                                                                                     image:@"bundle://setting.png"
                                                                                       URL:@"tt://setting" canDelete:YES] autorelease],nil], nil];
    [self.view addSubview:_launcherView];
    
    UIBarButtonItem* _bbtnSignOut = [[UIBarButtonItem alloc] initWithTitle:@"Sign out" style:UIBarButtonItemStylePlain target:self action:@selector(onBbtnSigtOut)];
    [self.navigationItem setLeftBarButtonItem:_bbtnSignOut];
    
    [self changeOrientation:_interfaceOrientation];
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
        [_launcherView setFrame:CGRectMake(0, 0, 768, 960)];
        _launcherView.columnCount = 4;
        [_nvMessengerViewController.view setFrame:CGRectMake(0, 0, 768, 960)];
        [_messengerViewController._tblvUsers setFrame:CGRectMake(0, 0, 768, 960)];
	}
	if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{
        [_launcherView setFrame:CGRectMake(0, 0, 1024, 704)];
        _launcherView.columnCount = 5;
        [_nvMessengerViewController.view setFrame:CGRectMake(0, 0, 1024, 704)];
        [_messengerViewController._tblvUsers setFrame:CGRectMake(0, 0, 1024, 704)];
	}
    
}


// TTLauncherViewDelegate
- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item 
{
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.supportsShakeToReload = YES;
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    
    TTURLMap* map = navigator.URLMap;
    [map from:@"*" toViewController:[HomeViewController_iPad class]];
    [map from: @"tt://homeview" toSharedViewController: [HomeViewController_iPad class]];
    
    if ([item.title isEqualToString:@"Activity Streams"]) 
    {
        [map from: item.URL
           parent: @"tt://homeview"
 toViewController: [ActivityStreamsViewController_iPad class]
         selector: nil
       transition: 0];
    }
    
    if ([item.title isEqualToString:@"Chat"]) 
    {
        if (_messengerViewController == nil) 
        {
            _messengerViewController = [[MessengerViewController alloc] initWithNibName:@"MessengerViewController" bundle:nil];
            [_messengerViewController setDelegate:self];
            
        }
        
        if (_nvMessengerViewController == nil) 
        {
            _nvMessengerViewController = [[UINavigationController alloc] initWithRootViewController:_messengerViewController];
        }
        
        [_messengerViewController initMessengerParameters];
        [_messengerViewController._tblvUsers reloadData];
        //[self.navigationController.view addSubview:_nvMessengerViewController.view];
        
        if ([self.navigationController.viewControllers containsObject:_messengerViewController])
        {
            [self.navigationController popToViewController:_messengerViewController animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:_messengerViewController animated:YES];
        }
    
    }
    
    if ([item.title isEqualToString:@"Documents"]) 
    {
        if (_filesViewController == nil) 
        {
            _filesViewController = [[FilesViewController alloc] initWithNibName:@"FilesViewController" bundle:nil];
            [_filesViewController setDelegate:self];
            [_filesViewController initWithRootDirectory];
            [_filesViewController getPersonalDriveContent:_filesViewController._currenteXoFile];
        }
        
        if ([self.navigationController.viewControllers containsObject:_filesViewController])
        {
            [self.navigationController popToViewController:_filesViewController animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:_filesViewController animated:YES];
        }
    }
    
    if ([item.title isEqualToString:@"Dashboard"]) 
    {
        [map from: item.URL
           parent: @"tt://homeview"
 toViewController: [DashboardViewController_iPad class]
         selector: nil
       transition: 0];
    }
    
    if([item.title isEqualToString:@"Settings"]) 
    {
        eXoSettingViewController* setting = [[eXoSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [map from: @"tt://setting"
           parent: @"tt://homeview"
 toViewController: setting
         selector: nil
       transition: 0];
    }
    
    //TTOpenURLFromView(item.URL, self.view);
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher 
{
    [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                 target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher 
{
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

- (void)onBbtnSigtOut
{
    [_delegate onBtnSigtOutDelegate];
}

- (void)setCurrentViewIndex:(short)index
{
	_currentViewIndex = index;
}

- (short)getCurrentViewIndex
{
	return _currentViewIndex;
}

- (int)getCurrentChatUserIndex
{
	return [_messengerViewController getCurrentChatUserIndex];
}

- (void)setCurrentChatUserIndex:(int)index
{
	[_messengerViewController setCurrentChatUserIndex:index];
}

- (void)setLeftBarButtonForNavigationBar;
{
	if(_currentViewIndex != 3)
	{
		[self.view addSubview:_imgViewNewMessage];
		return;
	}
    
	NSArray *arrChatUsers = [_messengerViewController getArrChatUsers];
	MessengerUser* messengerUser;
	
	for(int i = 0; i < [arrChatUsers count]; i++)
	{
		messengerUser = [arrChatUsers objectAtIndex:i];
		if(messengerUser._intMessageCount > 0)
		{
			[self.view addSubview:_imgViewNewMessage];
			return;
		}
	}
    
	[_imgViewNewMessage removeFromSuperview];
}

- (void)showChatWindowWithUser:(MessengerUser*)messengerUser andXMPPClient:(XMPPClient*)xmppClient
{
    if (_chatWindowViewController == nil) 
    {
        _chatWindowViewController = [[ChatWindowViewController alloc] initWithNibName:@"ChatWindowViewController" bundle:nil];
        [_chatWindowViewController setDelegate:self];
    }
    
	[_chatWindowViewController initChatWindowWithUser:messengerUser andXMPPClient:xmppClient];
	
	if([_nvMessengerViewController.viewControllers containsObject:_chatWindowViewController])
	{
		[_nvMessengerViewController popToViewController:_chatWindowViewController animated:YES];
	}
	else 
	{
		[_nvMessengerViewController pushViewController:_chatWindowViewController animated:YES];
		//[self showChatToolBar:NO];
	}
}

- (MessengerViewController*)getMessengerViewController
{
	return _messengerViewController;
}

- (void)addChatButton:(XMPPUser *)user userIndex:(int)index
{
    /*
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
			[_toolBarChatsLive setItems:_liveChatArr];
		}
	}	
    */ 
}

- (void)removeChatButton:(int)index
{
    /*
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
    */ 
}

-(void)showLiveChat:(UIButton *)sender
{
    /*
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
    */ 
}

- (void)openChatWindows:(int)index
{
	[self setCurrentViewIndex:3];
	MessengerUser* messengerUser = [[_messengerViewController getArrChatUsers] objectAtIndex:index]; 
	messengerUser._intMessageCount = 0;
	[self setLeftBarButtonForNavigationBar];
	_messengerViewController.currentChatUserIndex = index;	
	[self showChatWindowWithUser:messengerUser andXMPPClient:[MessengerViewController getXmppClient]];
	[_messengerViewController._tblvUsers reloadData];
}

-(void)chatWindows:(UIButton *)sender
{
	//[_liveChatArr removeObjectAtIndex:[sender tag]];
	[self openChatWindows:sender.tag];
}

- (void)showChatToolBar:(BOOL)show
{
    /*
	[_toolBarChatsLive setHidden:!show];
	if(show)
	{
		[[self view] bringSubviewToFront:_toolBarChatsLive];
	}
     */
}

@end
