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
#import "iPadSettingViewController.h"

#import "eXoMobileViewController.h"
#import "FilesViewController.h"
#import "XMPPUser.h"
#import "Connection.h"
#import "GadgetDisplayController.h"
#import "Configuration.h"
#import "iPadSettingViewController.h"
#import "iPadServerManagerViewController.h"
#import "iPadServerAddingViewController.h"
#import "iPadServerEditingViewController.h"
#import "defines.h"

@implementation HomeViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"Home";
        _arrViewOfViewControllers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc 
{
    [_conn release];
    if (_dashboardViewController_iPad) 
    {
        [_dashboardViewController_iPad release];
    }
    if (_gadgetDisplayController) 
    {
        [_gadgetDisplayController release];
    }
    if (_iPadSettingViewController) 
    {
        [_iPadSettingViewController release];
    }
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController release];
    }
    if (_iPadServerAddingViewController) 
    {
        [_iPadServerAddingViewController release];
    }
    if (_iPadServerEditingViewController) 
    {
        [_iPadServerEditingViewController release];
    }
    [_arrViewOfViewControllers release];
    [super dealloc];
}

- (void)loadView 
{
    [super loadView];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_intSelectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
	NSString* filePath;
	if(_intSelectedLanguage == 0)
	{
		filePath = [[NSBundle mainBundle] pathForResource:@"Localize_EN" ofType:@"xml"];
	}	
	else
	{	
		filePath = [[NSBundle mainBundle] pathForResource:@"Localize_FR" ofType:@"xml"];
	}	
	
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	[[self navigationItem] setTitle:[_dictLocalize objectForKey:@"SignInPageTitle"]];	
    
    
    _conn = [[Connection alloc] init];
    
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
    [self moveView];
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
        [self.navigationController.view addSubview:_nvMessengerViewController.view];
        
//        if ([self.navigationController.viewControllers containsObject:_messengerViewController])
//        {
//            [self.navigationController popToViewController:_messengerViewController animated:YES];
//        }
//        else
//        {
//            [self.navigationController pushViewController:_messengerViewController animated:YES];
//        }
    
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
        //[map from: item.URL parent: @"tt://homeview" toViewController: [DashboardViewController_iPad class] selector: nil transition: 0];
        if (_dashboardViewController_iPad == nil) 
        {
            _dashboardViewController_iPad = [[DashboardViewController_iPad alloc] initWithNibName:@"DashboardViewController_iPad" bundle:nil];
            [_dashboardViewController_iPad setDelegate:self];
            _dashboardViewController_iPad._arrTabs = [_conn getItemsInDashboard];
        }
        
        if ([self.navigationController.viewControllers containsObject:_dashboardViewController_iPad]) 
        {
            [self.navigationController popToViewController:_dashboardViewController_iPad animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:_dashboardViewController_iPad animated:YES];
        }
    }
    
    if([item.title isEqualToString:@"Settings"]) 
    {
        if (_iPadSettingViewController == nil) 
        {
            _iPadSettingViewController = [[iPadSettingViewController alloc] initWithNibName:@"iPadSettingViewController" bundle:nil];
            [_iPadSettingViewController setDelegate:self];
            [self.view addSubview:_iPadSettingViewController.view];
        }
        [self pushViewIn:_iPadSettingViewController.view];
        
        /*
        if ([self.navigationController.viewControllers containsObject:_iPadSettingViewController]) 
        {
            [self.navigationController popToViewController:_iPadSettingViewController animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:_iPadSettingViewController animated:YES];
        }
         */
        
        
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

- (void)onGadget:(Gadget_iPad*)gadget
{
    if (_gadgetDisplayController == nil) 
    {
        _gadgetDisplayController = [[GadgetDisplayController alloc] initWithNibName:@"GadgetDisplayController" bundle:nil];
        [_gadgetDisplayController setDelegate:self];

    }
    
    if ([self.navigationController.viewControllers containsObject:_gadgetDisplayController]) 
    {
        [self.navigationController popToViewController:_gadgetDisplayController animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:_gadgetDisplayController animated:YES];
    }
	[_gadgetDisplayController startGadget:gadget];
}

//===============================
- (int)getSelectedLanguage
{
	return _intSelectedLanguage;
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

- (void)pushViewIn:(UIView*)view
{
    [_arrViewOfViewControllers addObject:view];
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
        [view setFrame:CGRectMake(SCR_WIDTH_PRTR_IPAD, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD)];
        [self.view setFrame:CGRectMake(0, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD)];
	}
	
	if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
        [view setFrame:CGRectMake(SCR_WIDTH_LSCP_IPAD, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD)];
        [self.view setFrame:CGRectMake(0, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD)];
	}
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
    [self moveView];
    [UIView commitAnimations];
}

- (void)pullViewOut:(UIView*)viewController
{
    [self jumpToViewController:[_arrViewOfViewControllers count] - 2]; 
    [_arrViewOfViewControllers removeLastObject];
}

- (void)jumpToViewController:(int)index
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
    for (int i = 0; i < [_arrViewOfViewControllers count]; i++) 
    {
        UIView* tmpView = [_arrViewOfViewControllers objectAtIndex:i];
        int p = i - index;

        if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            [tmpView setFrame:CGRectMake(p*SCR_WIDTH_PRTR_IPAD, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD)];
        }
        
        if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        {	
            [tmpView setFrame:CGRectMake(p*SCR_WIDTH_LSCP_IPAD, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD)];
        }
    }
    [UIView commitAnimations];
}



- (void)moveView
{
    for (int i = 0; i < [_arrViewOfViewControllers count]; i++) 
    {
        UIView* tmpView = [_arrViewOfViewControllers objectAtIndex:i];
        [tmpView removeFromSuperview];
        
        int p = i - [_arrViewOfViewControllers count] + 1;
        if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            [tmpView setFrame:CGRectMake(p*SCR_WIDTH_PRTR_IPAD, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD)];
        }
        
        if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        {	
            [tmpView setFrame:CGRectMake(p*SCR_WIDTH_LSCP_IPAD, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD)];
        }
        [self.view addSubview:tmpView];
    }
    if (_iPadSettingViewController) 
    {
        [_iPadSettingViewController changeOrientation:_interfaceOrientation];
    }
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController changeOrientation:_interfaceOrientation];
    }
    if (_iPadServerAddingViewController) 
    {
        [_iPadServerAddingViewController changeOrientation:_interfaceOrientation];
    }
    if (_iPadServerEditingViewController) 
    {
        [_iPadServerEditingViewController changeOrientation:_interfaceOrientation];
    }
}

- (void)onBackDelegate
{
    [self pullViewOut:[_arrViewOfViewControllers lastObject]];
    if (_iPadSettingViewController) 
    {
        [_iPadSettingViewController.tblView reloadData];
    }
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController._tbvlServerList reloadData];
    }
    if (_iPadServerAddingViewController) 
    {
        [_iPadServerAddingViewController._tblvServerInfo reloadData];
    }
    if (_iPadServerEditingViewController) 
    {
        [_iPadServerEditingViewController._tblvServerInfo reloadData];
    }
}


- (void)showiPadServerManagerViewController
{
    if (_iPadServerManagerViewController == nil) 
    {
        _iPadServerManagerViewController = [[iPadServerManagerViewController alloc] initWithNibName:@"iPadServerManagerViewController" bundle:nil];
        [_iPadServerManagerViewController setDelegate:self];
        [_iPadServerManagerViewController setInterfaceOrientation:_interfaceOrientation];
        [self.view addSubview:_iPadServerManagerViewController.view];
    }
    [self pushViewIn:_iPadServerManagerViewController.view];
}


- (void)showiPadServerAddingViewController
{
    if (_iPadServerAddingViewController == nil) 
    {
        _iPadServerAddingViewController = [[iPadServerAddingViewController alloc] initWithNibName:@"iPadServerAddingViewController" bundle:nil];
        [_iPadServerAddingViewController setDelegate:self];
        [_iPadServerAddingViewController setInterfaceOrientation:_interfaceOrientation];
        [self.view addSubview:_iPadServerAddingViewController.view];
    }
    [_iPadServerAddingViewController._txtfServerName setText:@""];
    [_iPadServerAddingViewController._txtfServerUrl setText:@""];    
    [self pushViewIn:_iPadServerAddingViewController.view];
}

- (void)showiPadServerEditingViewControllerWithServerObj:(ServerObj*)serverObj andIndex:(int)index
{
    if (_iPadServerEditingViewController == nil) 
    {
        _iPadServerEditingViewController = [[iPadServerEditingViewController alloc] initWithNibName:@"iPadServerEditingViewController" bundle:nil];
        [_iPadServerEditingViewController setDelegate:self];
        [_iPadServerEditingViewController setInterfaceOrientation:_interfaceOrientation];
        [self.view addSubview:_iPadServerEditingViewController.view];
    }
    [_iPadServerEditingViewController setServerObj:serverObj andIndex:index];
    [self pushViewIn:_iPadServerEditingViewController.view];
}

- (void)editServerObjAtIndex:(int)intIndex withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController editServerObjAtIndex:intIndex withSeverName:strServerName andServerUrl:strServerUrl];
        [self pullViewOut:[_arrViewOfViewControllers lastObject]];
    }
}

- (void)deleteServerObjAtIndex:(int)intIndex
{
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController deleteServerObjAtIndex:intIndex];
    }
}

- (void)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    if(_iPadServerManagerViewController)
    {
        [_iPadServerManagerViewController addServerObjWithServerName:strServerName andServerUrl:strServerUrl]; 
        [self pullViewOut:[_arrViewOfViewControllers lastObject]];
    }    
}

//======================



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
 
}

- (void)removeChatButton:(int)index
{

}

-(void)showLiveChat:(UIButton *)sender
{
 
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

}

@end
