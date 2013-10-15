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
        
        [self.tabVC setViewControllers:[NSArray arrayWithObjects:recentsVC, peopleVC, dialVC, aboutVC, nil]];
        
        self.tabVC.delegate = self;
        self.tabVC.view.frame = self.view.frame;
        [self.view addSubview:self.tabVC.view];

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
@end
