//
//  RecentsTabViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 10/1/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "RecentsTabViewController_iPhone.h"

@interface RecentsTabViewController_iPhone ()

@end

@implementation RecentsTabViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Recents";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
