//
//  ContactsTabViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 10/1/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ContactsTabViewController_iPhone.h"

@interface ContactsTabViewController_iPhone ()

@end

@implementation ContactsTabViewController_iPhone


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Contacts";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];

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
