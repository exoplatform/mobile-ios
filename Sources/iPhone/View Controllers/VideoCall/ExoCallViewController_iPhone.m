//
//  ExoCallViewController_iPhone
//  eXo Platform
//
//  Created by vietnq on 9/30/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoCallViewController_iPhone.h"
#import "RecentsTabViewController_iPhone.h"
#import "DialViewController_iPhone.h"
#import "PeopleViewController_iPhone.h"
#import "AppDelegate_iPhone.h"

@interface ExoCallViewController_iPhone ()

@end

@implementation ExoCallViewController_iPhone
@synthesize tabVC = _tabVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tabVC = [[UITabBarController alloc] init];
        RecentsTabViewController_iPhone *recentsVC = [[[RecentsTabViewController_iPhone alloc] initWithNibName:@"RecentsTabViewController_iPhone" bundle:nil] autorelease];
        
        PeopleViewController_iPhone *peopleVC = [[[PeopleViewController_iPhone alloc] initWithNibName:@"PeopleViewController_iPhone" bundle:nil] autorelease];
        
        DialViewController_iPhone *dialVC = [[[DialViewController_iPhone alloc] initWithNibName:@"DialViewController_iPhone" bundle:nil] autorelease];
        
        [_tabVC setViewControllers:[NSArray arrayWithObjects:recentsVC, peopleVC, dialVC, nil]];
        _tabVC.delegate = self;
        _tabVC.view.frame = self.view.frame;
        [self.view addSubview:_tabVC.view];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
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
    if([viewController isKindOfClass:[RecentsTabViewController_iPhone class]]) {
        RecentsTabViewController_iPhone *recentsVC = (RecentsTabViewController_iPhone *)viewController;
        
        [recentsVC.tableView reloadData];
    }
}
@end
