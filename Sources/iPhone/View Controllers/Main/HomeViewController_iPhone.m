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
    
    UIBarButtonItem* bbtnSignOut = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onBbtnSignOut)];
    self.navigationItem.leftBarButtonItem = bbtnSignOut;
    [bbtnSignOut release];
    
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
    [_delegate onBtnSigtOutDelegate];
}
@end
