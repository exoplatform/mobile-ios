//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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
//        self.title = @"Home";
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
    [self initView];
}


- (void)initView
{
    
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
    self.title = Localize(@"Home");
    
    
    if(_launcherView != nil){
        [_launcherView release];
    }
    
    _launcherView = [[TTLauncherView alloc] initWithFrame:CGRectMake(0,5,self.view.frame.size.width, self.view.frame.size.height-120)];
    
    _launcherView.backgroundColor = [UIColor clearColor];
    _launcherView.delegate = self;
    _launcherView.columnCount = 3;
    _launcherView.pager.hidesForSinglePage = YES;

    
    TTLauncherItem *actStreamItem = [[[TTLauncherItem alloc] initWithTitle:Localize(@"News")
                                                                     image:@"bundle://HomeActivityStreamsIconiPhone.png"
                                                                       URL:@"tt://activityStream" canDelete:NO] autorelease];

    
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
        [self.navigationController presentViewController:navController animated:YES completion:nil];
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
    [self initView];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
