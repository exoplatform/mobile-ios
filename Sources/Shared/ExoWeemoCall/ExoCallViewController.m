//
//  ExoCallViewController.m
//  eXo Platform
//
//  Created by vietnq on 10/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoCallViewController.h"
#import "RecentsTabViewController.h"
#import "PeopleViewController.h"
#import "DialViewController.h"
#import "WeemoAboutViewController.h"
#import "JTNavigationView.h"
#import "AppDelegate_iPhone.h"

@interface ExoCallViewController ()

@end

@implementation ExoCallViewController
@synthesize tabVC = _tabVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabVC = [[UITabBarController alloc] init];
        
        BOOL isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        
        RecentsTabViewController *recentsVC = [[[RecentsTabViewController alloc] initWithNibName:isIpad ? @"RecentsTabViewController_iPad" : @"RecentsTabViewController_iPhone" bundle:nil] autorelease];
        
        PeopleViewController *peopleVC = [[[PeopleViewController alloc] initWithNibName:isIpad ? @"PeopleViewController_iPad" : @"PeopleViewController_iPhone" bundle:nil] autorelease];
        
        DialViewController *dialVC = [[[DialViewController alloc] initWithNibName:isIpad ? @"DialViewController_iPad" : @"DialViewController_iPhone" bundle:nil] autorelease];
        WeemoAboutViewController *aboutVC = [[[WeemoAboutViewController alloc] initWithNibName:isIpad ? @"WeemoAboutViewController_iPad" : @"WeemoAboutViewController_iPhone"  bundle:nil] autorelease];
        
        [self.tabVC setViewControllers:[NSArray arrayWithObjects: dialVC, peopleVC, recentsVC, aboutVC, nil]];
        
        self.tabVC.delegate = self;
        self.tabVC.view.frame = self.view.frame;
        
        [self addChildViewController:self.tabVC];
        [self.view addSubview:self.tabVC.view];
       
        self.view.title = dialVC.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    _tabVC = nil;
    [_tabVC release];
}

#pragma mark UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass:[RecentsTabViewController class]]) {
        RecentsTabViewController *recentsVC = (RecentsTabViewController *)viewController;
        [recentsVC.tableView reloadData];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationTitle:viewController.title];
    }
    
    return YES;
}

@end
