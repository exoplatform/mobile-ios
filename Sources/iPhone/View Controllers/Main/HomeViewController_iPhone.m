//
//  HomeViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "HomeViewController_iPhone.h"

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
#import "ActivityStreamsViewController_iPhone.h"
#import "ChatViewController_iPhone.h"
#import "DashboardViewController_iPhone.h"
#import "eXoSettingViewController.h"


@implementation HomeViewController_iPhone

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


- (void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillAppear:animated];
}


- (void)loadView 
{
    [super loadView];
    
    //Set the background Color of the view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
    //Force the status bar to be black opaque since TTViewController reset it
    self.statusBarStyle = UIStatusBarStyleBlackOpaque;
    
    //Add the eXo logo to the Navigation Bar
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eXoLogoNavigationBariPhone.png"]];
    self.navigationItem.titleView = img;
    [img release];
    
    // Create a custom logout button
    UIButton* logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *logoutImg = [UIImage imageNamed:@"HomeLogoutiPhone.png"];

    [logoutButton setImage:logoutImg forState:UIControlStateNormal];
    logoutButton.frame = CGRectMake(0, 0, logoutImg.size.width, logoutImg.size.height);
    
    [logoutButton addTarget:self action:@selector(onBbtnSignOut) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:logoutButton] autorelease];

    
    //Add the shadow at the bottom of the navigationBar
    UIImageView *navigationBarShadowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GlobalNavigationBarShadowIphone.png"]];
    navigationBarShadowImgV.frame = CGRectMake(0,0,navigationBarShadowImgV.frame.size.width,navigationBarShadowImgV.frame.size.height);
    [self.view addSubview:navigationBarShadowImgV];
    [navigationBarShadowImgV release];

    
    //Add the Notification Panel
    UIImageView *footerImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeNotificationPanelBgIphone.png"]];
    footerImgV.frame = CGRectMake(0,self.view.bounds.size.height-footerImgV.frame.size.height,footerImgV.frame.size.width,footerImgV.frame.size.height);
    [self.view addSubview:footerImgV];
    [footerImgV release];
    
    
    //Add the Global Grid behind the Launcher
    UIImage *imgGrid = [UIImage imageNamed:@"HomeBackgroundGridiPhone.png"];
    UIImageView *gridImgV = [[UIImageView alloc] initWithImage:imgGrid];
    gridImgV.frame = CGRectMake(0, 5, imgGrid.size.width, imgGrid.size.height);
    
    [self.view addSubview:gridImgV];
    
    _launcherView = [[TTLauncherView alloc] initWithFrame:CGRectMake(0,5,imgGrid.size.width, imgGrid.size.height+20)];
    
    //Now release the grid Image view
    [gridImgV release];

    
    _launcherView.backgroundColor = [UIColor clearColor];
    _launcherView.delegate = self;
    _launcherView.columnCount = 3;
    _launcherView.pager.hidesForSinglePage = YES;
    
    _launcherView.pages = [NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Activity Streams"
                                                                                     image:@"bundle://HomeActivityStreamsIconiPhone.png"
                                                                                       URL:@"tt://activityStream" canDelete:YES] autorelease],
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Chat"
                                                                                     image:@"bundle://HomeChatIconiPhone.png"
                                                                                       URL:@"tt://chat" canDelete:YES] autorelease],
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Documents"
                                                                                     image:@"bundle://HomeDocumentsIconiPhone.png"
                                                                                       URL:@"tt://documents" canDelete:YES] autorelease],
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Dashboard"
                                                                                     image:@"bundle://HomeDashboardIconiPhone.png"
                                                                                       URL:@"tt://dashboard" canDelete:YES] autorelease],
                                                    [[[TTLauncherItem alloc] initWithTitle:@"Settings"
                                                                                     image:@"bundle://HomeSettingsIconiPhone.png"
                                                                                       URL:@"tt://setting" canDelete:YES] autorelease],nil], nil];
    [self.view addSubview:_launcherView];
    
    
    
    

//    TTLauncherItem* item = [_launcherView itemWithURL:@"fb://item3"];
//    item.badgeNumber = 4;
//    
//    item = [_launcherView itemWithURL:@"fb://item4"];
//    item.badgeNumber = 0;
//    
//    item = [_launcherView itemWithURL:@"fb://item5"];
//    item.badgeValue = @"100!";
//    
//    item = [_launcherView itemWithURL:@"fb://item6"];
//    item.badgeValue = @"Off";
//    
//    item = [_launcherView itemWithURL:@"fb://item7"];
//    item.badgeNumber = 300;
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

// TTLauncherViewDelegate
- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item 
{
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.supportsShakeToReload = YES;
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    
    TTURLMap* map = navigator.URLMap;
    [map from:@"*" toViewController:[HomeViewController_iPhone class]];
    [map from: @"tt://homeview" toSharedViewController: [HomeViewController_iPhone class]];
    
    if ([item.title isEqualToString:@"Activity Streams"]) 
    {
        [map from: item.URL
           parent: @"tt://homeview"
 toViewController: [ActivityStreamsViewController_iPhone class]
         selector: nil
       transition: 0];
    }
    
    if ([item.title isEqualToString:@"Chat"]) 
    {
        [map from: item.URL
           parent: @"tt://homeview"
 toViewController: [ChatViewController_iPhone class]
         selector: nil
       transition: 0];
    }
    
    if ([item.title isEqualToString:@"Documents"]) 
    {
        [map from: item.URL
           parent: @"tt://homeview"
 toViewController: [FilesViewController_iPhone class]
         selector: nil
       transition: 0];
    }
    
    if ([item.title isEqualToString:@"Dashboard"]) 
    {
        [map from: item.URL
           parent: @"tt://homeview"
 toViewController: [DashboardViewController_iPhone class]
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
    
    TTOpenURLFromView(item.URL, self.view);
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

- (void)onBbtnSignOut
{
    //Back to Login with a PopViewController
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate onBtnSigtOutDelegate];
}




@end
