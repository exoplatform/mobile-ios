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
#import <iOS-SDK/Weemo.h>

@interface ExoCallViewController_iPhone ()

@end

@implementation ExoCallViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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


@end
