//
//  VideoCallViewController_iPhone
//  eXo Platform
//
//  Created by vietnq on 9/30/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "VideoCallViewController_iPhone.h"
#import "RecentsTabViewController_iPhone.h"
#import "ContactsTabViewController_iPhone.h"
#import "AppDelegate_iPhone.h"

@interface VideoCallViewController_iPhone ()

@end

@implementation VideoCallViewController_iPhone
@synthesize tabVC = _tabVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tabVC = [[UITabBarController alloc] init];
        RecentsTabViewController_iPhone *recentsVC = [[RecentsTabViewController_iPhone alloc] initWithNibName:@"RecentsTabViewController_iPhone" bundle:nil];
        ContactsTabViewController_iPhone *contactsVC = [[ContactsTabViewController_iPhone alloc] initWithNibName:@"ContactsTabViewController_iPhone" bundle:nil];
        [_tabVC setViewControllers:[NSArray arrayWithObjects:recentsVC, contactsVC, nil]];
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

@end
