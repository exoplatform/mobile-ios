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

#import "DocumentsViewController_iPhone.h"
#import "ActivityStreamBrowseViewController_iPhone.h"
#import "DashboardViewController_iPhone.h"
#import "SettingsViewController.h"
#import "MessengerViewController_iPhone.h"
#import "FilesProxy.h"

#import "LanguageHelper.h"
#import "AppDelegate_iPhone.h"

@implementation HomeViewController_iPhone

@synthesize _isCompatibleWithSocial;

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
    [_launcherView release];
    [super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
    // Create a custom logout button    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *barButtonImage = [UIImage imageNamed:@"HomeLogoutiPhone.png"];
    barButton.frame = CGRectMake(0, 0, barButtonImage.size.width, barButtonImage.size.height);
    [barButton setImage:[UIImage imageNamed:@"HomeLogoutiPhone.png"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(onBbtnSignOut) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    [self.navigationItem setLeftBarButtonItem:customItem];
    [customItem release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)loadView 
{
    [super loadView];
    
    //Set the background Color of the view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
    //Force the status bar to be black opaque since TTViewController reset it
    //self.statusBarStyle = UIStatusBarStyleBlackOpaque;
    
    //Add the eXo logo to the Navigation Bar
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eXoLogoNavigationBariPhone.png"]];
    self.navigationItem.titleView = img;
    [img release];
    
    self.navigationItem.hidesBackButton = YES;
    
    //Set the title of the controller
    //TODO Localize that
    self.title = Localize(@"Home");
    
    //Add the bubble background
    /*UIImageView* imgBubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeBubbleBackground.png"]];
    imgBubble.frame = CGRectMake(0, self.view.frame.size.height-imgBubble.frame.size.height, imgBubble.frame.size.width, imgBubble.frame.size.height);
    [self.view addSubview:imgBubble];
    [imgBubble release];
    */
    /*
     
     //Add the shadow at the bottom of the navigationBar
     UIImageView *navigationBarShadowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GlobalNavigationBarShadowIphone.png"]];
     navigationBarShadowImgV.frame = CGRectMake(0,0,navigationBarShadowImgV.frame.size.width,navigationBarShadowImgV.frame.size.height);
     [self.view addSubview:navigationBarShadowImgV];
     [navigationBarShadowImgV release];
     
     */
    
    if(_launcherView != nil){
        [_launcherView release];
    }
    
    _launcherView = [[TTLauncherView alloc] initWithFrame:CGRectMake(0,5,self.view.frame.size.width, self.view.frame.size.height-120)];
    
    _launcherView.backgroundColor = [UIColor clearColor];
    _launcherView.delegate = self;
    _launcherView.columnCount = 3;
    _launcherView.pager.hidesForSinglePage = YES;

    
    //TODO Localize
    TTLauncherItem *actStreamItem = [[[TTLauncherItem alloc] initWithTitle:Localize(@"News")
                                                                     image:@"bundle://HomeActivityStreamsIconiPhone.png"
                                                                       URL:@"tt://activityStream" canDelete:NO] autorelease];
    
//    TTLauncherItem *chatItem = [[[TTLauncherItem alloc] initWithTitle:Localize(@"Chat")
//                                                                image:@"bundle://HomeChatIconiPhone.png"
//                                                                  URL:@"tt://chat" canDelete:NO] autorelease];
    
    TTLauncherItem *documentItem = [[[TTLauncherItem alloc] initWithTitle:Localize(@"Documents")
                                                                    image:@"bundle://HomeDocumentsIconiPhone.png"
                                                                      URL:@"tt://documents" canDelete:NO] autorelease];
    
    TTLauncherItem *dashboardItem = [[[TTLauncherItem alloc] initWithTitle:Localize(@"Dashboard")
                                                                     image:@"bundle://HomeDashboardIconiPhone.png"
                                                                       URL:@"tt://dashboard" canDelete:NO] autorelease];
    
    TTLauncherItem *settingItem = [[[TTLauncherItem alloc] initWithTitle:Localize(@"Settings")
                                                                   image:@"bundle://HomeSettingsIconiPhone.png"
                                                                     URL:@"tt://setting" canDelete:NO] autorelease];
    if(_isCompatibleWithSocial)
        _launcherView.pages = [NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                                         actStreamItem, documentItem, dashboardItem, settingItem, nil], nil];
    else
        _launcherView.pages = [NSArray arrayWithObjects:[NSArray arrayWithObjects: documentItem, dashboardItem, settingItem, nil], nil];    
    [self.view addSubview:_launcherView];
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

// TTLauncherViewDelegate
- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item 
{
    //    UIButton* logoutButton = (UIButton *)[self.navigationController.navigationBar viewWithTag:111];
    
    if ([item.title isEqualToString:Localize(@"News")]) 
    {
        ActivityStreamBrowseViewController_iPhone* _activityStreamBrowseViewController_iPhone = [[ActivityStreamBrowseViewController_iPhone alloc] initWithNibName:@"ActivityStreamBrowseViewController_iPhone" bundle:nil];
        [self.navigationController pushViewController:_activityStreamBrowseViewController_iPhone animated:YES];
        [_activityStreamBrowseViewController_iPhone release];
    }
    
    if ([item.title isEqualToString:Localize(@"Chat"])) 
    {
        //Start the Chat
        MessengerViewController_iPhone *messengerViewController_iPhone = [[MessengerViewController_iPhone alloc] initWithNibName:@"MessengerViewController_iPhone" bundle:nil];
        [self.navigationController pushViewController:messengerViewController_iPhone animated:YES];
        [messengerViewController_iPhone release];
    }
    
    if ([item.title isEqualToString:Localize(@"Documents")]) 
    {
        //Start Documents
        DocumentsViewController_iPhone *documentsViewController = [[DocumentsViewController_iPhone alloc] initWithNibName:@"DocumentsViewController_iPhone" bundle:nil];
        [self.navigationController pushViewController:documentsViewController animated:YES];
        [documentsViewController release];
    }
    
    if ([item.title isEqualToString:Localize(@"Dashboard")]) 
    {
        
        //Start Dashboard
        
        DashboardViewController_iPhone *dashboardController = [[DashboardViewController_iPhone alloc] initWithNibName:@"DashboardViewController_iPhone" bundle:nil];
        [self.navigationController pushViewController:dashboardController animated:YES];
        [dashboardController release];
    }
    
    if([item.title isEqualToString:Localize(@"Settings")]) 
    {
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        settingsViewController.settingsDelegate = self;
        [settingsViewController startRetrieve];
        UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:settingsViewController] autorelease];
        [settingsViewController release];
        
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.navigationController presentModalViewController:navController animated:YES];
    }
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
    [_delegate onBtnSigtOutDelegate];
    
    //Back to Login with a PopViewController
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma - Settings Delegate Methods
- (void)doneWithSettings {
//    NSArray *listItems = _launcherView.pages;
//    for (TTLauncherItem *item in listItems){
//        
//    }
    [self loadView];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end
